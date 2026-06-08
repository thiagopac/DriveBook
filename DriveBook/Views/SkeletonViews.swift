import SwiftUI

struct SkeletonBlock: View {
    var cornerRadius: CGFloat = 8
    @State private var opacity: Double = 0.25

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color(white: 0.28))
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                    opacity = 0.55
                }
            }
    }
}

struct HomeSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SkeletonBlock(cornerRadius: 18)
                .frame(height: 230)
                .padding(.top, 28)

            HStack(spacing: 6) {
                ForEach(0..<4, id: \.self) { i in
                    SkeletonBlock(cornerRadius: 3)
                        .frame(width: i == 0 ? 18 : 6, height: 5)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 10)

            HStack {
                SkeletonBlock(cornerRadius: 6).frame(width: 160, height: 20)
                Spacer()
                SkeletonBlock(cornerRadius: 6).frame(width: 50, height: 14)
            }
            .padding(.top, 28)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        SkeletonBlock(cornerRadius: 12).frame(width: 155, height: 175)
                    }
                }
            }
            .padding(.top, 12)
            .disabled(true)

            SkeletonBlock(cornerRadius: 6).frame(width: 120, height: 20).padding(.top, 28)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<5, id: \.self) { _ in
                        SkeletonBlock(cornerRadius: 20).frame(width: 80, height: 36)
                    }
                }
            }
            .padding(.top, 12)
            .disabled(true)
        }
    }
}

struct BrowseSkeleton: View {
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(0..<7, id: \.self) { _ in
                BrowseRowSkeleton()
                Divider()
                    .background(Color.white.opacity(0.08))
                    .padding(.leading, 16)
            }
        }
    }
}

struct BrowseRowSkeleton: View {
    var body: some View {
        HStack(spacing: 14) {
            SkeletonBlock(cornerRadius: 10).frame(width: 90, height: 64)
            VStack(alignment: .leading, spacing: 7) {
                SkeletonBlock(cornerRadius: 4).frame(width: 56, height: 11)
                SkeletonBlock(cornerRadius: 4).frame(width: 130, height: 15)
                SkeletonBlock(cornerRadius: 4).frame(width: 90, height: 11)
            }
            Spacer()
            VStack(spacing: 14) {
                SkeletonBlock(cornerRadius: 8).frame(width: 20, height: 18)
                SkeletonBlock(cornerRadius: 4).frame(width: 10, height: 12)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

struct GarageSkeleton: View {
    var body: some View {
        VStack(spacing: 14) {
            ForEach(0..<3, id: \.self) { _ in
                GarageCardSkeleton()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}

struct GarageCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SkeletonBlock(cornerRadius: 0).frame(maxWidth: .infinity).frame(height: 170)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 7) {
                        SkeletonBlock(cornerRadius: 4).frame(width: 70, height: 11)
                        SkeletonBlock(cornerRadius: 4).frame(width: 150, height: 19)
                        SkeletonBlock(cornerRadius: 4).frame(width: 50, height: 11)
                    }
                    Spacer()
                    SkeletonBlock(cornerRadius: 8).frame(width: 60, height: 42)
                }
                Divider().background(Color.white.opacity(0.1))
                HStack(spacing: 18) {
                    ForEach(0..<3, id: \.self) { _ in
                        SkeletonBlock(cornerRadius: 5).frame(width: 55, height: 14)
                    }
                    Spacer()
                }
            }
            .padding(14)
        }
        .background(Color(white: 0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
