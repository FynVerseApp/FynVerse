import SwiftUI

struct WikiDescriptionView: View {
    let title: String
    @State private var summary: WikiSummary?
    @State private var isLoading = true
    @State private var fetchFailed = false

    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView("Fetching Wikipedia Info...")
                    .task {
                        await loadSummary()
                    }
            } else if let summary = summary {
                VStack(alignment: .leading, spacing: 12) {
                    if let imageUrl = summary.thumbnail?.source,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    }

                    Text(summary.title)
                        .font(.title2)
                        .bold()

                    Text(summary.extract)
                        .font(.body)

                    Link("Read more on Wikipedia",
                         destination: URL(string: summary.contentUrls.desktop.page)!)
                        .foregroundColor(.blue)
                        .padding(.top)
                }
                .padding()
            } else if fetchFailed {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.yellow)
                    
                    Text("No Wikipedia info available for “\(title)”")
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .navigationTitle("About \(title)")
    }

    private func loadSummary() async {
        isLoading = true
        let result = await WikiService.shared.fetchSummary(for: title)
        if let result = result {
            summary = result
        } else {
            fetchFailed = true
        }
        isLoading = false
    }
}

#Preview {
    WikiDescriptionView(title: "Tata Consultancy Services")
}
