import Foundation

@Observable
class HomeViewModel {
    var featured: [VehicleListing] = []
    var popular: [VehicleListing] = []
    var brands: [Brand] = []
    var isLoading = false

    func loadAll() async {
        isLoading = true
        defer { isLoading = false }
        do {
            featured = try await APIService.fetchFeatured()
            popular = try await APIService.fetchPopular()
            brands = try await APIService.fetchBrands()
        } catch {
            print("load error: \(error)")
        }
    }
}
