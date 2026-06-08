import Foundation

enum APIService {
    static let baseURL = "https://raw.githubusercontent.com/thiagopac/DriveBook/main/backend/api/v1"

    static func fetch<T: Decodable>(_ path: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }

    static func fetchFeatured() async throws -> [VehicleListing] {
        let response: VehicleListResponse = try await fetch("home/featured.json")
        return response.data
    }

    static func fetchPopular() async throws -> [VehicleListing] {
        let response: VehicleListResponse = try await fetch("home/popular.json")
        return response.data
    }

    static func fetchBrands() async throws -> [Brand] {
        let response: BrandListResponse = try await fetch("home/brands.json")
        return response.data
    }

    static func fetchBrowse(category: String) async throws -> (total: Int, vehicles: [VehicleListing]) {
        let response: BrowseListResponse = try await fetch("browse/\(category).json")
        return (response.total ?? response.data.count, response.data)
    }

    static func fetchVehiclePhotos(vin: String) async throws -> [String] {
        let response: PhotosResponse = try await fetch("vehicles/\(vin)/photos.json")
        return response.data.retail
    }
}
