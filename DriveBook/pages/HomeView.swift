//
//  HomeView.swift
//  DriveBook
//
//  Created by Thiago Castro on 05/06/26.
//


import SwiftUI

struct HomeView: View {
    

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                HomeHeaderView()

                HomeTitleView()

                HomeSearchInputView()

                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    HomeView()
}

#Preview {
    HomeView()
}
