import Foundation

struct VehicleInfo: Codable {
    let make: String
    let model: String
    let trim: String?
    let year: Int
    let bodyStyle: String?
    let drivetrain: String?
    let engine: String?
    let fuel: String?
    let transmission: String?
    let exteriorColor: String?
    let type: String?

    var displayModelName: String {
        guard let t = trim, t != "Unspecified" else { return model }
        return "\(model) \(t)"
    }
}

struct RetailListing: Codable {
    let primaryImage: String?
    let price: Int?
    let city: String?
    let state: String?
    let dealer: String?
    let miles: Int?
    let used: Bool?
    let cpo: Bool?
    let photoCount: Int?
}

struct AppSpecs: Codable {
    let horsepower: Int?
    let acceleration: String?
    let topSpeed: String?
    let fuelEconomy: String?
    let drivetrain: String?
    let category: String?
    let description: String?
    let keyFeatures: [String]?
}

struct VehicleListing: Codable, Identifiable {
    let vin: String
    let vehicle: VehicleInfo
    let retailListing: RetailListing
    let appSpecs: AppSpecs

    var id: String { vin }
}

struct VehicleListResponse: Codable {
    let data: [VehicleListing]
}
