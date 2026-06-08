import SwiftUI

struct FavoritesView: View {
    @State private var vehicles: [VehicleListing] = []
    @State private var isLoading = true

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if isLoading {
                    ScrollView(showsIndicators: false) {
                        BrowseSkeleton()
                    }
                } else if vehicles.isEmpty {
                    emptyState
                } else {
                    countBar
                        .padding(.top, 12)
                        .padding(.bottom, 4)

                    Divider().background(Color.white.opacity(0.1))

                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(vehicles) { vehicle in
                                NavigationLink(value: vehicle) {
                                    VehicleRowView(vehicle: vehicle, isInitiallyFavorite: true)
                                        .padding(.horizontal, 16)
                                }
                                .buttonStyle(.plain)

                                Divider()
                                    .background(Color.white.opacity(0.08))
                                    .padding(.leading, 16)
                            }
                        }
                    }
                }
            }
        }
        .navigationDestination(for: VehicleListing.self) { VehicleDetailView(vehicle: $0) }
        .task { await load() }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("Favorites")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                Text("Vehicles you've saved")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.5))
            }
            Spacer()
            Image(systemName: "heart.fill")
                .font(.system(size: 20))
                .foregroundStyle(Color(red: 0.64, green: 0.58, blue: 1.0))
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    private var countBar: some View {
        HStack {
            Text("\(vehicles.count) saved")
                .font(.system(size: 13))
                .foregroundStyle(.white.opacity(0.5))
            Spacer()
            Button {} label: {
                HStack(spacing: 4) {
                    Text("Sort by: Recent")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.7))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private var emptyState: some View {
        VStack(spacing: 18) {
            Spacer()
            Image(systemName: "heart.slash")
                .font(.system(size: 48))
                .foregroundStyle(Color(white: 0.3))
            VStack(spacing: 6) {
                Text("No favorites yet")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                Text("Tap the heart on any vehicle\nto save it here.")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
    }

    private func load() async {
        isLoading = true
        async let electricResult = APIService.fetchBrowse(category: "electric")
        async let hybridResult = APIService.fetchBrowse(category: "hybrid")

        let electric = (try? await electricResult)?.vehicles ?? []
        let hybrid = (try? await hybridResult)?.vehicles ?? []

        var merged = electric + hybrid
        var seen = Set<String>()
        merged = merged.filter { seen.insert($0.vin).inserted }

        vehicles = Array(merged.prefix(8))
        isLoading = false
    }
}
