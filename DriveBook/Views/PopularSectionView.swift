import SwiftUI

struct PopularSectionView: View {
    let vehicles: [VehicleListing]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Popular This Week")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Button("See all") {}
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(red: 0.64, green: 0.58, blue: 1.0))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(vehicles) { vehicle in
                        PopularCarCard(vehicle: vehicle)
                    }
                }
            }
        }
    }
}

struct PopularCarCard: View {
    let vehicle: VehicleListing
    @State private var isFavorite = false

    private let cardBg = Color(white: 0.11)

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                if let raw = vehicle.retailListing.primaryImage, let url = URL(string: raw) {
                    AsyncImage(url: url) { img in
                        img.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        cardBg
                    }
                    .frame(width: 155, height: 210)
                    .clipped()
                } else {
                    cardBg.frame(width: 155, height: 210)
                }

                LinearGradient(
                    colors: [.clear, cardBg.opacity(0.6), cardBg],
                    startPoint: UnitPoint(x: 0.5, y: 0.35),
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 2) {
                    Text(vehicle.vehicle.make)
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.6))
                    Text(vehicle.vehicle.displayModelName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Text(String(vehicle.vehicle.year))
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.6))
                    if let hp = vehicle.appSpecs.horsepower {
                        Text("\(hp) HP")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.top, 2)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button {
                isFavorite.toggle()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 14))
                    .foregroundStyle(isFavorite ? .red : .white)
                    .padding(7)
                    .background(Color.black.opacity(0.45))
                    .clipShape(Circle())
            }
            .padding(8)
        }
        .frame(width: 155)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
