import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        HStack {
            Text("DriveBook")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            Image(systemName: "bell")
                .font(.system(size: 22, weight: .regular))
                .foregroundStyle(.white)
        }
        .padding(.top, 8)
    }
}
