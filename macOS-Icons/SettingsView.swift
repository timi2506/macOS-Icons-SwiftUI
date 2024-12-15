import SwiftUI

struct SettingsView: View {
    var body: some View {
            TabView {
                SettingsTab()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Tab1")
                    }
                AboutTab()
                    .tabItem {
                        Image(systemName: "info.circle")
                        Text("About")
                    }
            }
    }
}

struct SettingsTab: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("API Key") var apiKey = ""
    @AppStorage("firstLaunch") var firstLaunch = true
    @State private var showPassword = false
    var body: some View {
        List {
            Section("API Key") {
                if showPassword {
                    HStack {
                        TextField("API Key", text: $apiKey)
                            .autocorrectionDisabled(true)
                        Button(action:{
                            showPassword.toggle()
                        })
                        {
                            Image(systemName: "eye.slash")
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                else {
                    HStack {
                        SecureField("API Key", text: $apiKey)
                        Button(action:{
                            showPassword.toggle()
                        })
                        {
                            Image(systemName: "eye")
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            Section("Advanced") {
                VStack {
                    Button("Show Welcome Screen again") {
                        dismiss.callAsFunction()
                        firstLaunch = true
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct AboutTab: View {
    var body: some View {
        VStack {
            VStack {
                Text("About macOS Icons")
                    .font(.title)
                    .bold()
                HStack (spacing: 1) {
                    Text("by ")
                    
                    Button("@timi2506") {
                        openURL(url: URL(string: "https://x.com/timi2506")!)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
            List {
                let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

                Section("Version " + appVersion!) {
                    Button("Follow me on Twitter") {
                            openURL(url: URL(string: "https://x.com/timi2506")!)
                        }
                    Button("More Projects") {
                            openURL(url: URL(string: "https://github.com/timi2506?tab=repositories")!)
                        }
                }
            }
        }
    }
    func openURL(url: URL) {
        #if os(iOS)
        UIApplication.shared.open(url)
        #elseif os(macOS)
        NSWorkspace.shared.open(url)
        #endif
    }
}
