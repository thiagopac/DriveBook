import SwiftUI

struct HomeSearchInputView: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.white.opacity(0.5))

            TextField("Search make, model or type", text: $searchText)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.white)
                .tint(Color(red: 0.64, green: 0.58, blue: 1.0))
        }
        .padding(.horizontal, 16)
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(white: 0.12))
        )
        .padding(.top, 20)
    }
}
