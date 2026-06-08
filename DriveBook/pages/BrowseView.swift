import SwiftUI

struct BrowseView: View {
    @State private var viewModel = BrowseViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                categoryPills
                    .padding(.top, 16)

                countSortBar
                    .padding(.top, 12)
                    .padding(.bottom, 4)

                Divider()
                    .background(Color.white.opacity(0.1))

                if viewModel.isLoading {
                    Spacer()
                    ProgressView().tint(.white)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.vehicles) { vehicle in
                                NavigationLink(value: vehicle) {
                                    VehicleRowView(vehicle: vehicle)
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
        .navigationDestination(for: VehicleListing.self) { vehicle in
            VehicleDetailView(vehicle: vehicle)
        }
        .task {
            await viewModel.load(category: .all)
        }
    }

    private var header: some View {
        HStack {
            Text("Browse")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
            Spacer()
            Button {
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var categoryPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(BrowseCategory.allCases, id: \.self) { cat in
                    let selected = viewModel.selectedCategory == cat
                    Text(cat.label)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(selected ? .black : .white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 9)
                        .background(selected ? Color.white : Color(white: 0.15))
                        .clipShape(Capsule())
                        .onTapGesture {
                            viewModel.selectedCategory = cat
                            Task { await viewModel.load(category: cat) }
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var countSortBar: some View {
        HStack {
            Text("\(viewModel.total) vehicles found")
                .font(.system(size: 13))
                .foregroundStyle(.white.opacity(0.5))
            Spacer()
            Button {
            } label: {
                HStack(spacing: 4) {
                    Text("Sort by: Popular")
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
}
