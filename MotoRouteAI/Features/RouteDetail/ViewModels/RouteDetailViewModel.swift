import Foundation
import Observation

@Observable
final class RouteDetailViewModel {
    var routePlan: RoutePlan

    init(routePlan: RoutePlan) {
        self.routePlan = routePlan
    }
}
