import SwiftUI
import SwiftData

@main
struct YekpFakeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Favorite.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject private var coordinator = NavigationCoordinator()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                BusinessListView()
                    .environmentObject(coordinator)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .webView(let title, let url):
                            BusinessWebView(title: title, url: url)
                        }
                    }
            }
            .modelContainer(sharedModelContainer)
        }
    }
}
