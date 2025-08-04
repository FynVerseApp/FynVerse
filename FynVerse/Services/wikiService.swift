import Foundation

struct WikiSummary: Codable {
    let title: String
    let extract: String
    let contentUrls: ContentURLs
    let thumbnail: Thumbnail?

    enum CodingKeys: String, CodingKey {
        case title, extract
        case contentUrls = "content_urls"
        case thumbnail
    }
}

struct ContentURLs: Codable {
    let desktop: URLInfo
}

struct URLInfo: Codable {
    let page: String
}

struct Thumbnail: Codable {
    let source: String
}

struct WikiAPIError: Codable {
    let type: String?
    let detail: String?
}

actor WikiService {
    static let shared = WikiService()
    private init() {}

    private var cache: [String: WikiSummary] = [:]

    func fetchSummary(for title: String) async -> WikiSummary? {
        let encodedTitle = title.replacingOccurrences(of: " ", with: "_")

        if let cached = cache[encodedTitle] {
            return cached
        }
        guard let url = URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(encodedTitle) Stock") else {
            print("❌ Invalid URL for title: \(title)")
            return nil
        }

        let request = URLRequest(url: url, timeoutInterval: 10)
        var attempt = 0

        while attempt < 2 {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                // Check HTTP response status
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let apiError = try? JSONDecoder().decode(WikiAPIError.self, from: data)
                    print("❌ Wikipedia API error for \(title): \(httpResponse.statusCode)\n\(apiError?.detail ?? "Unknown error")")
                    return nil
                }

                // Decode the expected response
                let summary = try JSONDecoder().decode(WikiSummary.self, from: data)
                cache[encodedTitle] = summary
                return summary

            } catch let decodingError as DecodingError {
                print("⚠️ Decoding error on attempt \(attempt + 1) for \(title): \(decodingError)")
                attempt += 1
            } catch {
                print("⚠️ Attempt \(attempt + 1) failed for \(title): \(error)")
                attempt += 1
            }
        }

        print("❌ Wikipedia fetch failed for: \(title)")
        return nil
    }
}
