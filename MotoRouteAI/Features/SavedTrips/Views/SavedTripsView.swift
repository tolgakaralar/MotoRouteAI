import SwiftUI

struct SavedTripsView: View {
    var body: some View {
        ContentUnavailableView(
            "No Saved Trips",
            systemImage: "bookmark",
            description: Text("Generated routes you save will appear here.")
        )
        .navigationTitle("Saved Trips")
    }
}

#Preview {
    NavigationStack {
        SavedTripsView()
    }
}
