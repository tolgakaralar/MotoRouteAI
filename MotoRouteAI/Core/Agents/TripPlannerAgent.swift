import Foundation

struct TripPlannerAgent {
    private let tripPlanningService: TripPlanningService

    init(tripPlanningService: TripPlanningService = MockTripPlanningService()) {
        self.tripPlanningService = tripPlanningService
    }

    func generatePlan(from request: TripRequest) async throws -> RoutePlan {
        try await tripPlanningService.generateRoutePlan(for: request)
    }
}
