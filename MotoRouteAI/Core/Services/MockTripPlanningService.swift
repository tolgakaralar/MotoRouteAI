import Foundation

protocol TripPlanningService {
    func generateRoutePlan(for request: TripRequest) async throws -> RoutePlan
}

struct MockTripPlanningService: TripPlanningService {
    func generateRoutePlan(for request: TripRequest) async throws -> RoutePlan {
        try await Task.sleep(for: .milliseconds(600))

        let days = max(1, request.numberOfDays)
        let baseDistance = distancePerDay(for: request.ridingStyle)
        let totalDistance = baseDistance * days
        let dayPlans = (1...days).map { day in
            RouteDayPlan(
                dayNumber: day,
                title: dayTitle(day: day, request: request),
                distance: baseDistance,
                rideHours: rideHours(for: request.ridingStyle),
                weatherRisk: day == days ? .moderate : .low,
                stops: stops(for: day, request: request)
            )
        }

        return RoutePlan(
            title: "\(request.origin) to \(request.destination)",
            summary: "A \(request.tripType.rawValue.lowercased()) motorcycle route tuned for a \(request.ridingStyle.rawValue.lowercased()) riding pace.",
            totalDistance: totalDistance,
            estimatedRideHours: dayPlans.reduce(0) { $0 + $1.rideHours },
            days: dayPlans,
            safetyInsights: [
                SafetyInsight(
                    title: "Plan fuel stops early",
                    detail: "The mock route includes remote stretches, so keep fuel above half a tank between major towns.",
                    risk: .moderate
                ),
                SafetyInsight(
                    title: "Watch afternoon weather",
                    detail: "Expect changing wind and visibility later in the day. Start earlier when possible.",
                    risk: .low
                )
            ]
        )
    }

    private func distancePerDay(for style: RidingStyle) -> Int {
        switch style {
        case .relaxed:
            return 180
        case .balanced:
            return 240
        case .spirited:
            return 300
        }
    }

    private func rideHours(for style: RidingStyle) -> Double {
        switch style {
        case .relaxed:
            return 4.0
        case .balanced:
            return 5.5
        case .spirited:
            return 6.5
        }
    }

    private func dayTitle(day: Int, request: TripRequest) -> String {
        if request.numberOfDays == 1 {
            return "Ride from \(request.origin) to \(request.destination)"
        }

        if day == 1 {
            return "Depart \(request.origin)"
        }

        if day == request.numberOfDays {
            return "Arrive in \(request.destination)"
        }

        return "Scenic connector day"
    }

    private func stops(for day: Int, request: TripRequest) -> [TripStop] {
        [
            TripStop(
                name: "Morning fuel stop",
                kind: .fuel,
                note: "Top off before the longest stretch of day \(day)."
            ),
            TripStop(
                name: request.tripType == .scenic ? "Viewpoint break" : "Lunch stop",
                kind: request.tripType == .scenic ? .viewpoint : .food,
                note: request.tripType == .scenic ? "Short photo stop with a low-effort detour." : "Simple midpoint break to manage fatigue."
            ),
            TripStop(
                name: request.accommodationPreference == .camping ? "Camp check-in" : "Overnight base",
                kind: request.accommodationPreference == .camping ? .camping : .lodging,
                note: "Matched to your \(request.accommodationPreference.rawValue.lowercased()) preference."
            )
        ]
    }
}
