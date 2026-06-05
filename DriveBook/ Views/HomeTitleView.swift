//
//  HomeTitleView.swift
//  DriveBook
//
//  Created by Thiago Castro on 05/06/26.
//


import SwiftUI

struct HomeTitleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: -4) {
            Text("Explore")
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(.white)

            Text("the world of cars")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Color(red: 0.64, green: 0.58, blue: 1.0))
        }
        .padding(.top, 26)
    }
}

#Preview {
    HomeTitleView()
}
