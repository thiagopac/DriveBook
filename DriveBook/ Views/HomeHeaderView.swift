//
//  HomeHeaderView.swift
//  DriveBook
//
//  Created by Thiago Castro on 05/06/26.
//


import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        HStack {
            Text("DriveBook")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            Image(systemName: "bell")
                .font(.system(size: 26, weight: .regular))
                .foregroundStyle(.white)
        }
        .padding(.top, 8)
    }
}

#Preview {
    HomeHeaderView()
}
