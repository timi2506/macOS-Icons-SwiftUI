import SwiftUI
import Alamofire

struct Icon: Identifiable, Codable {
    let id = UUID()
    let appName: String
    let icnsUrl: String
    let lowResPngUrl: String
    let downloads: Int
}

struct IconSearchResponse: Codable {
    let hits: [Icon]
    let query: String
    let totalHits: Int
}

struct ContentView: View {
    @State private var searchText = ""
    @State private var icons: [Icon] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showSettingsSheet = false
    @AppStorage("API Key") var apiKey = ""
    @AppStorage("firstLaunch") var firstLaunchSheet = true
    @AppStorage("APIkeySheet") var apikeysheet = false

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage + """
                         
                         
                         Please Check your API Key in Settings or if you are connected to Internet
                         """)
                        .foregroundColor(.red)
                        .padding()
                } else if icons.isEmpty {
                    if searchText == "" {
                        Text("Enter a search query in the Search Bar at the top")
                            .foregroundColor(.gray)
                            .padding(5)
                    }
                    else {
                        Text("Press Enter or Done to search for: " + searchText)
                            .foregroundColor(.gray)
                            .padding(5)
                    }
                    
                } else {
                    List(icons) { icon in
                        NavigationLink(destination: IconDetailView(icon: icon)) {
                            HStack {
                                AsyncImage(url: URL(string: icon.lowResPngUrl)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                }
                                VStack(alignment: .leading) {
                                    Text(icon.appName)
                                        .font(.headline)
                                    Text("Downloads: \(icon.downloads)")
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("macOS Icons")
            .searchable(text: $searchText, prompt: "Search macOS Icons")
            .onSubmit(of: .search) {
                searchIcons(query: searchText)
            }
            .toolbar {
                #if os(macOS)
                EmptyView()
                #else
                Button("Settings", systemImage: "gear") {
                    showSettingsSheet = true
                }
                #endif
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView()
            }
            .sheet(isPresented: $firstLaunchSheet) {
                IntroductionView()
            }
            .sheet(isPresented: $apikeysheet) {
                APIKeySheet()
            }
        }
        #if os(macOS)
        .navigationViewStyle(.automatic)
        #else
        .navigationViewStyle(.stack)
        #endif
    }
    
    func searchIcons(query: String) {
        guard !query.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        icons = []
        
        let apiUrl = "https://api.macosicons.com/api/search"
        let headers: HTTPHeaders = ["x-api-key": apiKey]
        let parameters: [String: Any] = [
            "query": query,
            "searchOptions": [
                "hitsPerPage": 20,
                "page": 1
            ]
        ]
        
        AF.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: IconSearchResponse.self) { response in
                isLoading = false
                switch response.result {
                case .success(let data):
                    icons = data.hits
                case .failure(let error):
                    errorMessage = "Error: \(error.localizedDescription)"
                }
            }
    }
}

struct IconDetailView: View {
    let icon: Icon
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: icon.lowResPngUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 300)
            .padding()
            
            Text(icon.appName)
                .font(.largeTitle)
                .padding()
            if let url = URL(string: icon.icnsUrl) {
                ShareLink(item: url) {
                    Label("Share Icon", systemImage: "square.and.arrow.up")
                }
            }
            Button(action: {
                if let url = URL(string: icon.icnsUrl) {
                    #if os(iOS)
                    UIApplication.shared.open(url)
                    #elseif os(macOS)
                    NSWorkspace.shared.open(url)
                    #endif
                }
            }) {
                Text("Download Icon")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
            .buttonStyle(.plain)
        }
        .padding()
        .navigationTitle(icon.appName)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}
