import SwiftUI

public struct TabItem<SomeScreen: Hashable & Identifiable>: Identifiable {
    let screen: SomeScreen
    let image: String?
    let systemImage: String?
    let title: String
    public let id = UUID()

    public init(screen: SomeScreen, title: String, image: String?) {
        self.screen = screen
        self.title = title
        self.image = image
        self.systemImage = nil
    }

    public init(screen: SomeScreen, title: String, systemImage: String?) {
        self.screen = screen
        self.title = title
        self.image = nil
        self.systemImage = systemImage
    }
}
