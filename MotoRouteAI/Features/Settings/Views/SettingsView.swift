import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section("Rider") {
                LabeledContent("Profile", value: "Default")
                LabeledContent("Units", value: "Metric")
            }

            Section("Services") {
                LabeledContent("Route Planning", value: "Mock")
                LabeledContent("AI Agent", value: "Mock")
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
