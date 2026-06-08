import Foundation

@Observable
class HomeViewModel {
    var featured: [VehicleListing] = []
    var popular: [VehicleListing] = []
    var brands: [Brand] = []
    var isLoading = false

    func loadAll() async {
        guard featured.isEmpty else { return }
        isLoading = true
        async let feat = APIService.fetchFeatured()
        async let pop = APIService.fetchPopular()
        async let brds = APIService.fetchBrands()
        featured = (try? await feat) ?? []
        popular = (try? await pop) ?? []
        brands = (try? await brds) ?? []
        isLoading = false
    }
}
