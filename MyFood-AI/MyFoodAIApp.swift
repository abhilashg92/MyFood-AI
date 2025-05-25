import SwiftUI

// MARK: - MyFoodAIApp
/// Main entry point for the MyFood-AI application
@main
struct MyFoodAIApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ImageCaptureView()
                    .navigationTitle("MyFood AI")
            }
        }
    }
} 