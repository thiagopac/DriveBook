import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var searchText = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                HomeHeaderView()
                    .padding(.horizontal, 16)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        HomeTitleView()

                        HomeSearchInputView(searchText: $searchText)

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

                        Spacer(minLength: 32)
                    }
                    .padding(.horizontal, 16)
                }
            }

            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
            }
        }
        .task {
            await viewModel.loadAll()
        }
    }
}

#Preview {
    HomeView()
}
