//
//  NavigationContainer.swift
//  SwiftUINavigation
//
//  Created by Miguel Vieira on 26/10/25.
//

import SwiftUI

public struct NavigationContainer<ParentRouter: ParentRouterProtocol, ViewFactory: ViewFactoryProtocol, Content: View>: View where ViewFactory.SomeScreen == ParentRouter.SomeScreen {
    @StateObject private var router: ParentRouter.ChildRouterType
    private var content: (any NavigatorProtocol<ViewFactory.SomeScreen>) -> Content
    private let viewFactory: ViewFactory
    
    public init(
        parentRouter: ParentRouter,
        tab: ParentRouter.SomeScreen,
        viewFactory: ViewFactory,
        @ViewBuilder content: @escaping (any NavigatorProtocol<ViewFactory.SomeScreen>) -> Content
    ) {
        self._router = .init(wrappedValue: parentRouter.childRouter(for: tab))
        self.viewFactory = viewFactory
        self.content = content
    }
    
    public var body: some View {
        let _ = Self._printChanges()

        navigationStackView(for: content(router), path: $router.navigationPath)
            .sheet(item: $router.sheet) { screen in
                navigationStackView(for: viewFactory.view(for: screen, navigator: router), path: $router.sheetNavigationPath)
            }
            .fullScreenCover(item: $router.fullScreenCover) { screen in
                navigationStackView(for: viewFactory.view(for: screen, navigator: router), path: $router.fullScreenCoverNavigationPath)
            }
    }
    
    private func navigationStackView(for view: some View, path: Binding<[ParentRouter.SomeScreen]>) -> some View {
        NavigationStack(path: path) {
            view
                .environmentObject(router)
                .navigationDestination(for: ParentRouter.SomeScreen.self) { screen in
                    viewFactory.view(for: screen, navigator: router)
                        .environmentObject(router)
                }
        }
    }
}

