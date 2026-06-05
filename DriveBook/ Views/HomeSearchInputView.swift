//
//  HomeSearchInputView.swift
//  DriveBook
//
//  Created by Thiago Castro on 05/06/26.
//


import SwiftUI

struct HomeSearchInputView: View {
    
    @State private var searchText = ""
    
    var body: some View {
        
        HStack(spacing: 18) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 30, weight: .regular))
                .foregroundStyle(.white.opacity(0.55))

            TextField("Search make, model or type", text: $searchText)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .tint(Color(red: 0.64, green: 0.58, blue: 1.0))
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(
            Capsule()
                .fill(Color(red: 0.09, green: 0.10, blue: 0.13))
        )
        .padding(.top, 22)
    }
}

#Preview {
    HomeSearchInputView()
}
