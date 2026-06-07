import SwiftUI

struct FeaturedCarouselView: View {
    let vehicles: [VehicleListing]
    @State private var currentIndex = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Vehicle")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)

            TabView(selection: $currentIndex) {
                ForEach(Array(vehicles.enumerated()), id: \.offset) { index, vehicle in
                    FeaturedCarCard(vehicle: vehicle)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 230)
            .clipShape(RoundedRectangle(cornerRadius: 18))

            HStack(spacing: 6) {
                ForEach(0..<vehicles.count, id: \.self) { index in
                    Capsule()
                        .fill(index == currentIndex ? Color.white : Color.white.opacity(0.3))
                        .frame(width: index == currentIndex ? 18 : 6, height: 6)
                        .animation(.easeInOut(duration: 0.2), value: currentIndex)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct FeaturedCarCard: View {
    let vehicle: VehicleListing

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let raw = vehicle.retailListing.primaryImage, let url = URL(string: raw) {
                AsyncImage(url: url) { img in
                    img.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(white: 0.15)
                }
                .clipped()
            } else {
                Color(white: 0.15)
            }

            LinearGradient(
                colors: [.clear, .black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(vehicle.vehicle.make.uppercased())
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.65))

                Text(vehicle.vehicle.displayModelName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)

                Text(String(vehicle.vehicle.year))
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.65))

                HStack(spacing: 20) {
                    if let hp = vehicle.appSpecs.horsepower {
                        statView(value: "\(hp) HP", label: "POWER")
                    }
                    if let acc = vehicle.appSpecs.acceleration {
                        statView(value: acc, label: "0-100 KM/H")
                    }
                }
                .padding(.top, 2)

                HStack(spacing: 10) {
                    Text("View details")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)

                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 30, height: 30)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color(white: 0.12))
                    }
                }
                .padding(.top, 8)
            }
            .padding(16)
        }
        .background(Color(white: 0.12))
    }

    private func statView(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(.white.opacity(0.55))
        }
    }
}
