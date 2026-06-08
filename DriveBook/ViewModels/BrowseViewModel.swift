import Foundation

enum BrowseCategory: String, CaseIterable {
    case all, sports, suv, sedan, electric, hybrid

    var label: String {
        switch self {
        case .all: "All"
        case .sports: "Sports"
        case .suv: "SUV"
        case .sedan: "Sedan"
        case .electric: "Electric"
        case .hybrid: "Hybrid"
        }
    }
}

@Observable
class BrowseViewModel {
    var vehicles: [VehicleListing] = []
    var total: Int = 0
    var selectedCategory: BrowseCategory = .all
    var isLoading = false

    func load(category: BrowseCategory) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await APIService.fetchBrowse(category: category.rawValue)
            vehicles = result.vehicles
            total = result.total
        } catch {
            print("browse error: \(error)")
        }
    }
}
