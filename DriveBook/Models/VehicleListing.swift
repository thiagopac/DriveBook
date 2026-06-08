import Foundation

struct VehicleInfo: Codable {
    let make: String
    let model: String
    let trim: String?
    let year: Int
    let baseMsrp: Int?
    let baseInvoice: Int?
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

struct VehicleHistory: Codable {
    let accidentCount: Int?
    let accidents: Bool?
    let oneOwner: Bool?
    let ownerCount: Int?
    let personalUse: Bool?
    let usageType: String?
}

struct VehicleListing: Codable, Identifiable, Hashable {
    let vin: String
    let vehicle: VehicleInfo
    let retailListing: RetailListing
    let appSpecs: AppSpecs
    let history: VehicleHistory?

    var id: String { vin }

    static func == (lhs: VehicleListing, rhs: VehicleListing) -> Bool { lhs.vin == rhs.vin }
    func hash(into hasher: inout Hasher) { hasher.combine(vin) }
}

struct VehicleListResponse: Codable {
    let data: [VehicleListing]
}

struct BrowseListResponse: Codable {
    let total: Int?
    let data: [VehicleListing]
}

struct VehicleDetailResponse: Codable {
    let data: VehicleListing
}

struct PhotosData: Codable {
    let retail: [String]
}

struct PhotosResponse: Codable {
    let data: PhotosData
}
