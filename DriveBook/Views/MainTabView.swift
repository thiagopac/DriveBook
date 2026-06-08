import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
                    .navigationDestination(for: VehicleListing.self) { vehicle in
                        VehicleDetailView(vehicle: vehicle)
                    }
            }
            .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack {
                BrowseView()
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }

            NavigationStack {
                GarageView()
            }
            .tabItem { Label("Garage", systemImage: "car.fill") }

            NavigationStack {
                FavoritesView()
            }
            .tabItem { Label("Favorites", systemImage: "heart.fill") }

            NavigationStack {
                ProfileView()
            }
            .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(Color(red: 0.64, green: 0.58, blue: 1.0))
    }
}
