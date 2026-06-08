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
                ZStack {
                    Color.black.ignoresSafeArea()
                    Text("Garage").foregroundStyle(.white)
                }
            }
            .tabItem { Label("Garage", systemImage: "car.fill") }

            NavigationStack {
                ZStack {
                    Color.black.ignoresSafeArea()
                    Text("Favorites").foregroundStyle(.white)
                }
            }
            .tabItem { Label("Favorites", systemImage: "heart.fill") }

            NavigationStack {
                ZStack {
                    Color.black.ignoresSafeArea()
                    Text("Profile").foregroundStyle(.white)
                }
            }
            .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(Color(red: 0.64, green: 0.58, blue: 1.0))
    }
}
