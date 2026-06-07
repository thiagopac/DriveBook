import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            Text("Search")
                .tabItem { Label("Search", systemImage: "magnifyingglass") }

            Text("Garage")
                .tabItem { Label("Garage", systemImage: "car.fill") }

            Text("Favorites")
                .tabItem { Label("Favorites", systemImage: "heart.fill") }

            Text("Profile")
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(Color(red: 0.64, green: 0.58, blue: 1.0))
    }
}
