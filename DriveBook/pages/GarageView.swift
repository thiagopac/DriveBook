import SwiftUI

struct GarageView: View {
    @State private var vehicles: [VehicleListing] = []
    @State private var isLoading = true

    private let accent = Color(red: 0.64, green: 0.58, blue: 1.0)

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if isLoading {
                    ScrollView(showsIndicators: false) {
                        GarageSkeleton()
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 14) {
                            ForEach(Array(vehicles.enumerated()), id: \.element.id) { idx, vehicle in
                                NavigationLink(value: vehicle) {
                                    GarageCard(vehicle: vehicle, index: idx)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 24)
                    }
                }
            }
        }
        .navigationDestination(for: VehicleListing.self) { VehicleDetailView(vehicle: $0) }
        .task { await load() }
    }

    private var header: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 3) {
                Text("My Garage")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                Text(isLoading ? "" : "\(vehicles.count) vehicles")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.5))
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(Color(white: 0.14))
                    .frame(width: 38, height: 38)
                Image(systemName: "plus")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }

    private func load() async {
        isLoading = true
        if let result = try? await APIService.fetchBrowse(category: "sports") {
            vehicles = Array(result.vehicles.prefix(4))
        }
        isLoading = false
    }
}

struct GarageCard: View {
    let vehicle: VehicleListing
    let index: Int

    private let accent = Color(red: 0.64, green: 0.58, blue: 1.0)
    private let cardBg = Color(white: 0.08)

    private var mockedMileage: Int {
        let seed = vehicle.vin.unicodeScalars.map { Int($0.value) }.reduce(0, +)
        return (seed % 55000) + 8000
    }

    private var formattedMileage: String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        return fmt.string(from: NSNumber(value: mockedMileage)) ?? "\(mockedMileage)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            photoArea

            infoArea
        }
        .background(cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var photoArea: some View {
        ZStack(alignment: .topTrailing) {
            if let raw = vehicle.retailListing.primaryImage, let url = URL(string: raw) {
                AsyncImage(url: url) { img in
                    img.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(white: 0.15)
                }
                .frame(height: 170)
                .clipped()
            } else {
                Color(white: 0.15).frame(height: 170)
            }

            categoryBadge
                .padding(12)
        }
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 16, bottomLeadingRadius: 0,
                                         bottomTrailingRadius: 0, topTrailingRadius: 16))
    }

    @ViewBuilder
    private var categoryBadge: some View {
        if let cat = vehicle.appSpecs.category {
            Text(cat)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.black.opacity(0.55))
                .clipShape(Capsule())
        }
    }

    private var infoArea: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(vehicle.vehicle.make)
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.45))
                    Text(vehicle.vehicle.displayModelName)
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(.white)
                    Text(String(vehicle.vehicle.year))
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.45))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(formattedMileage)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(accent)
                    Text("miles")
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.4))
                }
            }

            Divider().background(Color.white.opacity(0.1))

            HStack(spacing: 18) {
                if let hp = vehicle.appSpecs.horsepower {
                    specChip(icon: "bolt.fill", label: "\(hp) HP")
                }
                if let acc = vehicle.appSpecs.acceleration {
                    specChip(icon: "stopwatch", label: acc)
                }
                if let top = vehicle.appSpecs.topSpeed {
                    specChip(icon: "gauge.high", label: top)
                }
            }
        }
        .padding(14)
    }

    private func specChip(icon: String, label: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundStyle(accent)
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.75))
        }
    }
}
