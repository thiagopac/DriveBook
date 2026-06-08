import SwiftUI
import Foundation

struct VehicleDetailView: View {
    let vehicle: VehicleListing
    @State private var photos: [String] = []
    @State private var currentPhoto = 0
    @State private var isFavorite = false
    @State private var descriptionExpanded = false
    @Environment(\.dismiss) private var dismiss

    private let accent = Color(red: 0.64, green: 0.58, blue: 1.0)
    private let purple = Color(red: 0.38, green: 0.32, blue: 0.82)
    private let boxBg = Color(white: 0.95)
    private let photoHeight: CGFloat = 350
    private let cardOffset: CGFloat = 300

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            scrollContent
            navButtons
        }
        .ignoresSafeArea(edges: .top)
        .toolbar(.hidden, for: .navigationBar)
        .task { await loadPhotos() }
    }

    // MARK: - Scroll layer

    private var scrollContent: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .top) {
                photoLayer
                pagingDots.padding(.top, cardOffset - 30).allowsHitTesting(false)
                cardLayer
            }
            .frame(maxWidth: .infinity)
        }
        .coordinateSpace(name: "detailScroll")
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Photo with parallax

    private var photoLayer: some View {
        GeometryReader { geo in
            let scrollY = geo.frame(in: .named("detailScroll")).minY
            let isRubberBand = scrollY > 0
            let frameH = isRubberBand ? photoHeight + scrollY : photoHeight
            let offsetY = isRubberBand ? -scrollY : -scrollY * 0.7

            TabView(selection: $currentPhoto) {
                ForEach(Array(displayPhotos.enumerated()), id: \.offset) { i, urlStr in
                    AsyncImage(url: URL(string: urlStr)) { img in
                        img.resizable().scaledToFill()
                    } placeholder: {
                        Color(white: 0.12)
                    }
                    .frame(width: geo.size.width, height: max(frameH, photoHeight))
                    .clipped()
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: geo.size.width, height: max(frameH, photoHeight))
            .offset(y: offsetY)
        }
        .frame(height: photoHeight)
    }

    // MARK: - Card that slides over photo

    private var cardLayer: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: cardOffset)
                .allowsHitTesting(false)
            infoCard
            Color.white.frame(height: 100)
        }
    }

    // MARK: - Paging dots

    private var pagingDots: some View {
        HStack(spacing: 5) {
            ForEach(0..<max(displayPhotos.count, 1), id: \.self) { i in
                Capsule()
                    .fill(i == currentPhoto ? Color.white : Color.white.opacity(0.4))
                    .frame(width: i == currentPhoto ? 16 : 5, height: 5)
                    .animation(.easeInOut(duration: 0.2), value: currentPhoto)
            }
        }
    }

    // MARK: - Nav buttons (fixed over scroll)

    private var navButtons: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            Spacer()
            Button { isFavorite.toggle() } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(isFavorite ? .red : .white)
                    .frame(width: 38, height: 38)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 68)
    }

    // MARK: - White info card

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 10)

            subtitleRow
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

            statsSection
                .padding(.horizontal, 16)
                .padding(.bottom, 24)

            Divider().padding(.horizontal, 20)

            aboutSection
                .padding(.horizontal, 20)
                .padding(.top, 20)

            keyFeaturesSection
                .padding(.horizontal, 20)
                .padding(.top, 20)

            addToGarageButton
                .padding(.horizontal, 20)
                .padding(.top, 28)
                .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(TopRoundedShape(radius: 26))
    }

    // MARK: - Card content

    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(vehicle.vehicle.make)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(vehicle.vehicle.displayModelName)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.black)
                    Text(String(vehicle.vehicle.year))
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 12)
            priceBox
        }
    }

    @ViewBuilder
    private var priceBox: some View {
        if let msrp = vehicle.vehicle.baseMsrp ?? vehicle.retailListing.price {
            VStack(alignment: .center, spacing: 10) {
                Text(priceString(msrp))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(accent)
                Text("Estimated Price")
                    .font(.system(size: 10))
                    .foregroundStyle(accent)
                
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(boxBg)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    private var subtitleRow: some View {
        let cat = vehicle.appSpecs.category ?? ""
        let drive = vehicle.appSpecs.drivetrain ?? vehicle.vehicle.drivetrain ?? ""
        return Text("\(cat) • \(drive)")
            .font(.system(size: 13))
            .foregroundStyle(.secondary)
    }

    private var statsSection: some View {
        HStack(spacing: 8) {
            statBox(icon: "bolt.fill",
                    value: vehicle.appSpecs.horsepower.map { "\($0) HP" } ?? "—",
                    label: "Power")
            statBox(icon: "stopwatch",
                    value: vehicle.appSpecs.acceleration ?? "—",
                    label: "0-100 km/h")
            statBox(icon: "gauge.high",
                    value: vehicle.appSpecs.topSpeed ?? "—",
                    label: "Top Speed")
            statBox(icon: "fuelpump.fill",
                    value: (vehicle.appSpecs.fuelEconomy ?? "—")
                        .replacingOccurrences(of: "/", with: "/\n"),
                    label: "Fuel Economy")
        }
    }

    private func statBox(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(accent)
            Text(value)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Text(label)
                .font(.system(size: 9))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
        .background(boxBg)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("About")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.black)
            if let desc = vehicle.appSpecs.description {
                Text(descriptionExpanded ? desc : (String(desc.prefix(120)) + "..."))
                    .font(.system(size: 14))
                    .foregroundStyle(Color(white: 0.25))
                    .lineSpacing(3)
                Button { descriptionExpanded.toggle() } label: {
                    HStack(spacing: 4) {
                        Text(descriptionExpanded ? "Show less" : "Show more")
                        Image(systemName: descriptionExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(accent)
                }
            }
        }
    }

    @ViewBuilder
    private var keyFeaturesSection: some View {
        if let features = vehicle.appSpecs.keyFeatures, !features.isEmpty {
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
    }

    private var addToGarageButton: some View {
        Button {} label: {
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

    // MARK: - Helpers

    private var displayPhotos: [String] {
        if !photos.isEmpty { return Array(photos.prefix(8)) }
        if let img = vehicle.retailListing.primaryImage { return [img] }
        return []
    }

    private func priceString(_ amount: Int) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.currencyCode = "USD"
        fmt.maximumFractionDigits = 0
        return fmt.string(from: NSNumber(value: amount)) ?? "$\(amount)"
    }

    private func loadPhotos() async {
        guard let list = try? await APIService.fetchVehiclePhotos(vin: vehicle.vin) else { return }
        photos = list
    }
}

// MARK: - Top-only rounded shape

private struct TopRoundedShape: Shape {
    let radius: CGFloat
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        p.addQuadCurve(to: CGPoint(x: rect.minX + radius, y: rect.minY),
                       control: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + radius),
                       control: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}
