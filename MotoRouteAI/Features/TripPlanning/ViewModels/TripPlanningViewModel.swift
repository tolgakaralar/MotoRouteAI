import Foundation
import Observation

@MainActor
@Observable
final class TripPlanningViewModel {
    var origin = "Istanbul"
    var destination = "Kas"
    var tripType: TripType = .scenic
    var ridingStyle: RidingStyle = .balanced
    var accommodationPreference: AccommodationPreference = .flexible
    var numberOfDays = 3
    var isGenerating = false
    var errorMessage: String?

    @ObservationIgnored private let agent: TripPlannerAgent

    init() {
        self.agent = TripPlannerAgent()
    }

    init(agent: TripPlannerAgent) {
        self.agent = agent
    }

    var canGenerateRoute: Bool {
        !origin.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !destination.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !isGenerating
    }

    func generateRoute() async -> RoutePlan? {
        guard canGenerateRoute else { return nil }

        isGenerating = true
        errorMessage = nil

        let request = TripRequest(
            origin: origin.trimmingCharacters(in: .whitespacesAndNewlines),
            destination: destination.trimmingCharacters(in: .whitespacesAndNewlines),
            tripType: tripType,
            ridingStyle: ridingStyle,
            accommodationPreference: accommodationPreference,
            numberOfDays: numberOfDays
        )

        do {
            let routePlan = try await agent.generatePlan(from: request)
            isGenerating = false
            return routePlan
        } catch {
            errorMessage = "Could not generate a route. Try again."
            isGenerating = false
            return nil
        }
    }
}
