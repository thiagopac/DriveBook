import Foundation

struct Brand: Codable, Identifiable {
    let id: String
    let name: String
}

struct BrandListResponse: Codable {
    let data: [Brand]
}
