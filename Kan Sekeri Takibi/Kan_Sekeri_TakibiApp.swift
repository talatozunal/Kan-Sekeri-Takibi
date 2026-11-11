import SwiftUI

@main
struct MyApp: App {
    @StateObject private var dil = Yerellestirme()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dil)
                .environment(\.locale, dil.locale)
        }
    }
}
