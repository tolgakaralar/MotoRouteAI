import SwiftUI

struct AppRootView: View {
    @State private var path: [RoutePlan] = []

    var body: some View {
        TabView {
            NavigationStack(path: $path) {
                TripPlanningView { routePlan in
                    path.append(routePlan)
                }
                .navigationDestination(for: RoutePlan.self) { routePlan in
                    RouteDetailView(routePlan: routePlan)
                }
            }
            .tabItem {
                Label("Plan", systemImage: "map")
            }

            NavigationStack {
                SavedTripsView()
            }
            .tabItem {
                Label("Saved", systemImage: "bookmark")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }
}

#Preview {
    AppRootView()
}
