import SwiftUI

private enum RootScreenType<SomeScreen: Hashable & Identifiable> {
    case tabbed([TabItem<SomeScreen>])
    case single(SomeScreen)
}

public struct AppRootView<ParentRouter: ParentRouterProtocol, ViewFactory: ViewFactoryProtocol>: View
where ViewFactory.SomeScreen == ParentRouter.SomeScreen {
    @StateObject private var router: ParentRouter
    private let viewFactory: ViewFactory
    private let rootScreenType: RootScreenType<ParentRouter.SomeScreen>

    public init(router: ParentRouter, viewFactory: ViewFactory, tabItems: [TabItem<ParentRouter.SomeScreen>]) {
        self._router = .init(wrappedValue: router)
        self.viewFactory = viewFactory
        self.rootScreenType = .tabbed(tabItems)
    }

    public init(router: ParentRouter, viewFactory: ViewFactory, rootScreen: ParentRouter.SomeScreen) {
        self._router = .init(wrappedValue: router)
        self.viewFactory = viewFactory
        self.rootScreenType = .single(rootScreen)
    }

    public var body: some View {
        let _ = Self._printChanges()

        switch rootScreenType {
            case .tabbed(let tabItems):
                tabbedView(for: tabItems)
            case .single(let screen):
                singleView(for: screen)
        }
    }

    private func tabbedView(for tabItems: [TabItem<ParentRouter.SomeScreen>]) -> some View {
        TabView(selection: $router.selectedTab) {
            ForEach(tabItems) { tabItem in
                if let image = tabItem.image {
                    Tab(tabItem.title, image: image, value: tabItem.screen) {
                        singleView(for: tabItem.screen)
                    }
                } else if let systemImage = tabItem.systemImage {
                    Tab(tabItem.title, systemImage: systemImage, value: tabItem.screen) {
                        singleView(for: tabItem.screen)
                    }
                }
            }
        }
    }

    private func singleView(for screen: ParentRouter.SomeScreen) -> some View {
        NavigationContainer(parentRouter: router, tab: screen, viewFactory: viewFactory) { router in
            viewFactory.view(for: screen, navigator: router)
        }
    }
}

private extension Visibility {
    init(_ value: Bool) {
        if value {
            self = .visible
        } else {
            self = .hidden
        }
    }
}
