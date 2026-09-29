# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

MotoRouteAI is a SwiftUI iOS app for planning motorcycle trips. The user fills in a trip request,
an "agent" generates a multi-day `RoutePlan`, and the app shows it in a detail screen. The planning
backend is currently a mock (`MockTripPlanningService`) — there is no real AI/network integration yet.

Requirements: Xcode 26+ (project created with 26.6), iOS deployment target 26.5, Swift 5 language
mode. No third-party
dependencies (no SPM packages, no CocoaPods).

## Workflow rules

- Never push directly to `main`. Every change goes on its own branch and lands via a PR.
- Before opening a PR or pushing, review the branch against `main` with the
  `superpowers:requesting-code-review` skill. Do not open the PR until all Critical and Important
  findings are fixed.

## CI

Bitrise runs build, tests and SwiftLint on every PR; a PR cannot be merged until the build passes.
Building and testing are handled there — don't run local `xcodebuild` builds/tests as part of
routine work. Single Xcode project, single target/scheme `MotoRouteAI`; there is no test target yet.

## Build settings that affect code

- **Default actor isolation is `MainActor`** (`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`) and
  **Approachable Concurrency** is on. Every type is implicitly `@MainActor` unless marked
  `nonisolated`. This includes `TripPlanningService` and `MockTripPlanningService` — a real
  network/LLM service will need `nonisolated` or `@concurrent` work to stay off the main actor.
- **`MemberImportVisibility`** upcoming feature is on: each file must itself `import` the module
  whose members it uses (transitive imports from other files don't count).
- The project uses **file-system synchronized groups** (`PBXFileSystemSynchronizedRootGroup`):
  new `.swift` files placed under `MotoRouteAI/` are picked up automatically — do not edit
  `project.pbxproj` to register files.

## Architecture

Feature-based MVVM with the Observation framework:

- Entry point is `MotoRouteAIApp.swift` (at the target root, not in `App/`), which shows
  `AppRootView`. `ContentView.swift` is a leftover wrapper that nothing uses — don't build on it.
- `App/AppRootView.swift` — `TabView` with three tabs (Plan, Saved, Settings), each in its own
  `NavigationStack`. The Plan tab owns a `[RoutePlan]` navigation path; `TripPlanningView` reports a
  generated plan through its `onGeneratedRoute` closure and the root pushes `RouteDetailView` via
  `.navigationDestination(for: RoutePlan.self)`. Views do not navigate themselves.
- `Features/<Feature>/{Views,ViewModels}` — ViewModels are `@Observable final class`es held by
  their view in `@State` (initialized via `_viewModel = State(initialValue:)`); a view that binds
  to VM properties declares `@Bindable var viewModel = viewModel` inside `body`. Views that need
  injection expose a second `init(viewModel:...)` (currently only `TripPlanningView`).
- `Core/Models/TripModels.swift` — all domain value types (`TripRequest`, `RoutePlan`,
  `RouteDayPlan`, `TripStop`, `SafetyInsight`, `RiderProfile`) and their enums. Models are
  `Hashable` structs (required for `NavigationStack` value-based navigation); enums use
  user-facing `String` raw values that the UI displays directly.
- Planning pipeline: `TripPlanningViewModel` → `TripPlannerAgent` (`Core/Agents/`) →
  `TripPlanningService` protocol (defined in `Core/Services/MockTripPlanningService.swift`). A real
  LLM/routing backend should be a new `TripPlanningService` conformance. There is no DI container
  or composition root: `TripPlanningViewModel.init()` builds `TripPlannerAgent()`, whose default
  service is the mock. Swap it by changing that default in `TripPlannerAgent.init`, or inject via
  `TripPlanningViewModel(agent:)` → `TripPlanningView(viewModel:onGeneratedRoute:)` from
  `AppRootView`.
- `SavedTripsView` and `SettingsView` are static placeholders (no persistence, no settings state).
  `RiderProfile` exists in the models but is not wired into the UI yet.
