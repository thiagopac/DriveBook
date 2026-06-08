import SwiftUI

struct VehicleDetailView: View {
    let vehicle: VehicleListing
    @State private var photos: [String] = []
    @State private var currentPhoto = 0
    @State private var isFavorite = false
    @State private var descriptionExpanded = false
    @Environment(\.dismiss) private var dismiss

    private let accent = Color(red: 0.64, green: 0.58, blue: 1.0)
    private let purple = Color(red: 0.38, green: 0.32, blue: 0.82)

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                photoCarousel

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        infoCard
                    }
                }
                .background(Color.white)
                .clipShape(UnevenRoundedRectangle(
                    topLeadingRadius: 26,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 26
                ))
            }

            navOverlay

            addToGarageButton
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
        }
        .navigationBarHidden(true)
        .task {
            await loadPhotos()
        }
    }

    private var photoCarousel: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                TabView(selection: $currentPhoto) {
                    ForEach(Array(displayPhotos.enumerated()), id: \.offset) { i, url in
                        AsyncImage(url: URL(string: url)) { img in
                            img.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color(white: 0.12)
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                HStack(spacing: 5) {
                    ForEach(0..<displayPhotos.count, id: \.self) { i in
                        Capsule()
                            .fill(i == currentPhoto ? Color.white : Color.white.opacity(0.35))
                            .frame(width: i == currentPhoto ? 16 : 5, height: 5)
                            .animation(.easeInOut(duration: 0.2), value: currentPhoto)
                    }
                }
                .padding(.bottom, 16)
            }
        }
        .frame(height: 320)
    }

    private var displayPhotos: [String] {
        let list = photos.isEmpty
            ? (vehicle.retailListing.primaryImage.map { [$0] } ?? [])
            : Array(photos.prefix(8))
        return list
    }

    private var navOverlay: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.45))
                    .clipShape(Circle())
            }
            Spacer()
            Button { isFavorite.toggle() } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.red)
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.45))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 54)
        .ignoresSafeArea(edges: .top)
        .allowsHitTesting(true)
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection
                .padding(.horizontal, 20)
                .padding(.top, 22)
                .padding(.bottom, 8)

            Text("\(vehicle.appSpecs.category ?? "") • \(vehicle.appSpecs.drivetrain ?? vehicle.vehicle.drivetrain ?? "")")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

            Divider().padding(.horizontal, 20)

            statsRow
                .padding(.horizontal, 12)
                .padding(.vertical, 20)

            Divider().padding(.horizontal, 20)

            aboutSection
                .padding(.horizontal, 20)
                .padding(.top, 20)

            if let features = vehicle.appSpecs.keyFeatures, !features.isEmpty {
                keyFeaturesSection(features)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
            }

            Spacer(minLength: 100)
        }
    }

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(vehicle.vehicle.make)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(vehicle.vehicle.displayModelName)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.black)
                    Text(String(vehicle.vehicle.year))
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if let msrp = vehicle.vehicle.baseMsrp ?? vehicle.retailListing.price {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(msrp, format: .currency(code: "USD").precision(.fractionLength(0)))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(accent)
                    Text("Estimated Price")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var statsRow: some View {
        HStack(spacing: 0) {
            statCell(icon: "bolt.fill", value: vehicle.appSpecs.horsepower.map { "\($0) HP" } ?? "—", label: "Power")
            statCell(icon: "stopwatch", value: vehicle.appSpecs.acceleration ?? "—", label: "0-100 km/h")
            statCell(icon: "gauge.high", value: vehicle.appSpecs.topSpeed ?? "—", label: "Top Speed")
            statCell(icon: "fuelpump.fill", value: vehicle.appSpecs.fuelEconomy ?? "—", label: "Fuel Economy")
        }
    }

    private func statCell(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(accent)
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.black)
            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("About")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.black)

            if let desc = vehicle.appSpecs.description {
                let trimmed = descriptionExpanded ? desc : String(desc.prefix(120))
                Text(trimmed + (descriptionExpanded ? "" : "..."))
                    .font(.system(size: 14))
                    .foregroundStyle(Color(white: 0.25))
                    .lineSpacing(3)

                Button {
                    descriptionExpanded.toggle()
                } label: {
                    HStack(spacing: 4) {
                        Text(descriptionExpanded ? "Show less" : "Show more")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(accent)
                        Image(systemName: descriptionExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(accent)
                    }
                }
            }
        }
    }

    private func keyFeaturesSection(_ features: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Key Features")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.black)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(features, id: \.self) { feature in
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(purple)
                        Text(feature)
                            .font(.system(size: 14))
                            .foregroundStyle(Color(white: 0.15))
                    }
                }
            }
        }
    }

    private var addToGarageButton: some View {
        Button {
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "car.fill")
                Text("Add to Garage")
            }
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(purple)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private func loadPhotos() async {
        guard let list = try? await APIService.fetchVehiclePhotos(vin: vehicle.vin) else { return }
        photos = list
    }
}

