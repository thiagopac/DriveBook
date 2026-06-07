import SwiftUI

struct BrandsSectionView: View {
    let brands: [Brand]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Browse by Brand")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Button("See all") {}
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(red: 0.64, green: 0.58, blue: 1.0))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(brands) { brand in
                        Text(brand.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(Color(white: 0.13))
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
}
