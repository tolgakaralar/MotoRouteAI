import SwiftUI

struct TripPlanningView: View {
    @State private var viewModel: TripPlanningViewModel
    let onGeneratedRoute: (RoutePlan) -> Void

    init(onGeneratedRoute: @escaping (RoutePlan) -> Void) {
        _viewModel = State(initialValue: TripPlanningViewModel())
        self.onGeneratedRoute = onGeneratedRoute
    }

    init(viewModel: TripPlanningViewModel, onGeneratedRoute: @escaping (RoutePlan) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onGeneratedRoute = onGeneratedRoute
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        Form {
            Section("Route") {
                TextField("Origin", text: $viewModel.origin)
                    .textInputAutocapitalization(.words)

                TextField("Destination", text: $viewModel.destination)
                    .textInputAutocapitalization(.words)

                Stepper("Days: \(viewModel.numberOfDays)", value: $viewModel.numberOfDays, in: 1...7)
            }

            Section("Ride Preferences") {
                Picker("Trip Type", selection: $viewModel.tripType) {
                    ForEach(TripType.allCases) { tripType in
                        Text(tripType.rawValue).tag(tripType)
                    }
                }

                Picker("Riding Style", selection: $viewModel.ridingStyle) {
                    ForEach(RidingStyle.allCases) { ridingStyle in
                        Text(ridingStyle.rawValue).tag(ridingStyle)
                    }
                }

                Picker("Accommodation", selection: $viewModel.accommodationPreference) {
                    ForEach(AccommodationPreference.allCases) { preference in
                        Text(preference.rawValue).tag(preference)
                    }
                }
            }

            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button {
                    Task {
                        if let routePlan = await viewModel.generateRoute() {
                            onGeneratedRoute(routePlan)
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        if viewModel.isGenerating {
                            ProgressView()
                        } else {
                            Text("Generate Route")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                }
                .disabled(!viewModel.canGenerateRoute)
            }
        }
        .navigationTitle("Plan Trip")
    }
}

#Preview {
    NavigationStack {
        TripPlanningView { _ in }
    }
}
