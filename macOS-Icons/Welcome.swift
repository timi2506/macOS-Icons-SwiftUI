import SwiftUI

struct TitleView: View {
    var body: some View {
        VStack {
            Text("Welcome to")
                .customTitleText()

            Text("macOS Icons")
                .customTitleText()
                .foregroundColor(.accentColor)
        }
    }
}

struct IntroductionView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("firstLaunch") var firstLaunchSheet = true
    @AppStorage("API Key") var apiKey = ""
    @AppStorage("APIkeySheet") var apikeysheet = false

    
    var body: some View {

            VStack(alignment: .center) {
                TitleView()
                    .padding(75)
                
                Spacer()
                VStack {
                    HStack(alignment: .center) {
                        Image(systemName: "1.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .padding()
                            .accessibility(hidden: true)
                        
                        VStack(alignment: .leading) {
                            Text("Search")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .accessibility(addTraits: .isHeader)
                            
                            Text("Search for an Icon")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    
                    HStack(alignment: .center) {
                        Image(systemName: "2.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .padding()
                            .accessibility(hidden: true)
                        
                        VStack(alignment: .leading) {
                            Text("Preview")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .accessibility(addTraits: .isHeader)
                            
                            Text("Select and Preview an icon you likef")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    HStack(alignment: .center) {
                        Image(systemName: "3.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .padding()
                            .accessibility(hidden: true)
                        
                        VStack(alignment: .leading) {
                            Text("Download")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .accessibility(addTraits: .isHeader)
                            
                            Text("Download your favorite icon")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                }
                Spacer()
                
                Button(action: {
#if os(iOS)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
#endif
                    firstLaunchSheet = false
                    if apiKey == "" {
                        apikeysheet = true
                    }
                }) {
                    Text("Continue")
                        .customButton()
                }
                .padding()
                .buttonStyle(PlainButtonStyle())
            }
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.accentColor))
            .padding(.bottom)
    }
}

extension View {
    func customButton() -> ModifiedContent<Self, ButtonModifier> {
        return modifier(ButtonModifier())
    }
}

extension Text {
    func customTitleText() -> Text {
        self
            .fontWeight(.black)
            .font(.system(size: 36))
    }
}


struct APIKeySheet: View {
    @AppStorage("API Key") var apiKey = ""
    @State private var showPassword = false
    @Environment(\.dismiss) private var dismiss
    @State private var stillNoAPIkey = false
    
    var body: some View {
        VStack {
            Text("Please enter your macOSicons.com API Key")
                .font(.title)
                .bold()
            List {
                Section("API Key") {
                    VStack {
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
                        if stillNoAPIkey {
                            Text("You forgot to actually enter an API Key")
                                .foregroundStyle(.red)
                                .font(.caption)
                        }
                    }
                    .onChange(of: apiKey) {newValue in
                        stillNoAPIkey = false
                    }
                }
                Section("How to obtain an API Key?") {
                    Button("Guide") {
                        if let url = URL(string: "https://github.com/timi2506/macOS-Icons-SwiftUI/blob/main/api-key-guide.md") {
                            #if os(iOS)
                            UIApplication.shared.open(url)
                            #elseif os(macOS)
                            NSWorkspace.shared.open(url)
                            #endif
                        }
                    }
                }
            }
            .frame(minWidth: 100, minHeight: 150)
            Button("Continue") {
                if apiKey == "" {
                    stillNoAPIkey = true
                }
                else {
                    dismiss.callAsFunction()
                }
            }
        }
        .padding()
    }
}
