import SwiftUI

struct RouteDetailView: View {
    @State private var viewModel: RouteDetailViewModel

    init(routePlan: RoutePlan) {
        _viewModel = State(initialValue: RouteDetailViewModel(routePlan: routePlan))
    }

    var body: some View {
        let routePlan = viewModel.routePlan

        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(routePlan.title)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(routePlan.summary)
                        .foregroundStyle(.secondary)

                    HStack {
                        Label("\(routePlan.totalDistance) km", systemImage: "road.lanes")
                        Spacer()
                        Label(formattedHours(routePlan.estimatedRideHours), systemImage: "clock")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Day Plan") {
                ForEach(routePlan.days) { dayPlan in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Day \(dayPlan.dayNumber)")
                                .font(.headline)
                            Spacer()
                            Text(dayPlan.weatherRisk.rawValue)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(color(for: dayPlan.weatherRisk))
                        }

                        Text(dayPlan.title)
                            .foregroundStyle(.secondary)

                        HStack {
                            Label("\(dayPlan.distance) km", systemImage: "speedometer")
                            Label(formattedHours(dayPlan.rideHours), systemImage: "clock")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)

                        ForEach(dayPlan.stops) { stop in
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(stop.kind.rawValue): \(stop.name)")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(stop.note)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            Section("Safety") {
                ForEach(routePlan.safetyInsights) { insight in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(insight.title)
                                .font(.headline)
                            Spacer()
                            Text(insight.risk.rawValue)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(color(for: insight.risk))
                        }

                        Text(insight.detail)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Route Detail")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formattedHours(_ hours: Double) -> String {
        let wholeHours = Int(hours)
        let minutes = Int((hours - Double(wholeHours)) * 60)
        return "\(wholeHours)h \(minutes)m"
    }

    private func color(for risk: WeatherRisk) -> Color {
        switch risk {
        case .low:
            return .green
        case .moderate:
            return .orange
        case .high:
            return .red
        }
    }
}

#Preview {
    NavigationStack {
        RouteDetailView(
            routePlan: RoutePlan(
                title: "Istanbul to Kas",
                summary: "A scenic motorcycle route tuned for a balanced riding pace.",
                totalDistance: 720,
                estimatedRideHours: 16.5,
                days: [
                    RouteDayPlan(
                        dayNumber: 1,
                        title: "Depart Istanbul",
                        distance: 240,
                        rideHours: 5.5,
                        weatherRisk: .low,
                        stops: [
                            TripStop(name: "Morning fuel stop", kind: .fuel, note: "Top off before the longest stretch.")
                        ]
                    )
                ],
                safetyInsights: [
                    SafetyInsight(title: "Plan fuel stops early", detail: "Remote stretches are expected.", risk: .moderate)
                ]
            )
        )
    }
}
