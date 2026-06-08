import SwiftUI

struct VehicleRowView: View {
    let vehicle: VehicleListing
    @State private var isFavorite: Bool

    init(vehicle: VehicleListing, isInitiallyFavorite: Bool = false) {
        self.vehicle = vehicle
        self._isFavorite = State(initialValue: isInitiallyFavorite)
    }

    var body: some View {
        HStack(spacing: 14) {
            if let raw = vehicle.retailListing.primaryImage, let url = URL(string: raw) {
                AsyncImage(url: url) { img in
                    img.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(white: 0.18)
                }
                .frame(width: 90, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Color(white: 0.18)
                    .frame(width: 90, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(vehicle.vehicle.make)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.5))

                Text(vehicle.vehicle.displayModelName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text("\(vehicle.vehicle.year) • \(vehicle.appSpecs.category ?? vehicle.vehicle.bodyStyle ?? "")")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.5))

                HStack(spacing: 14) {
                    if let hp = vehicle.appSpecs.horsepower {
                        Label("\(hp) HP", systemImage: "bolt.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.75))
                            .labelStyle(compactLabel())
                    }
                    if let acc = vehicle.appSpecs.acceleration {
                        Label(acc, systemImage: "stopwatch")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.75))
                            .labelStyle(compactLabel())
                    }
                }
                .padding(.top, 1)
            }

            Spacer()

            VStack(spacing: 16) {
                Button {
                    isFavorite.toggle()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundStyle(isFavorite ? .red : .white.opacity(0.6))
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.35))
            }
        }
        .padding(.vertical, 14)
    }
}

private struct compactLabel: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.icon
            configuration.title
        }
    }
}
