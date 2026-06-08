import SwiftUI

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var searchText = ""
    @State private var scrollOffset: CGFloat = 0

    private var headerOpacity: Double {
        guard scrollOffset < 0 else { return 1 }
        return max(0, 1 + scrollOffset / 45)
    }

    private var compactTitleOpacity: Double {
        guard scrollOffset < -120 else { return 0 }
        return min(1, (-scrollOffset - 120) / 28)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    GeometryReader { geo in
                        Color.clear.preference(
                            key: ScrollOffsetKey.self,
                            value: geo.frame(in: .named("homeScroll")).minY
                        )
                    }
                    .frame(height: 0)

                    HomeHeaderView()
                        .opacity(headerOpacity)

                    HomeTitleView()

                    HomeSearchInputView(searchText: $searchText)

                    if viewModel.isLoading {
                        HomeSkeleton()
                    } else {
                        if !viewModel.featured.isEmpty {
                            FeaturedCarouselView(vehicles: viewModel.featured)
                                .padding(.top, 28)
                        }
                        if !viewModel.popular.isEmpty {
                            PopularSectionView(vehicles: viewModel.popular)
                                .padding(.top, 28)
                        }
                        if !viewModel.brands.isEmpty {
                            BrandsSectionView(brands: viewModel.brands)
                                .padding(.top, 28)
                        }
                    }

                    Spacer(minLength: 32)
                }
                .padding(.horizontal, 16)
            }
            .coordinateSpace(name: "homeScroll")
            .onPreferenceChange(ScrollOffsetKey.self) { value in
                scrollOffset = value
            }

            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Explore")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)
                        Text("the world of cars")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color(red: 0.64, green: 0.58, blue: 1.0))
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.black)

                Rectangle()
                    .fill(Color.white.opacity(0.08))
                    .frame(height: 0.5)
            }
            .opacity(compactTitleOpacity)

        }
        .task {
            await viewModel.loadAll()
        }
    }
}

#Preview {
    HomeView()
}
