import Combine

@MainActor
public protocol ChildRouterProtocol: ObservableObject, NavigatorProtocol {
    var correspondingTab: SomeScreen { get }
    var isActiveTab: Bool { get }

    var navigationPath: [SomeScreen] { get set }

    var sheet: SomeScreen? { get set }
    var sheetNavigationPath: [SomeScreen] { get set }

    var fullScreenCover: SomeScreen? { get set }
    var fullScreenCoverNavigationPath: [SomeScreen] { get set }
}

@MainActor
public protocol NavigatorProtocol<SomeScreen> where SomeScreen: Hashable {
    associatedtype SomeScreen: Hashable

    var isActiveTab: Bool { get }

    var navigationPath: [SomeScreen] { get }

    var sheet: SomeScreen? { get }
    var sheetNavigationPath: [SomeScreen] { get }
    var sheetDismissPublisher: AnyPublisher<SomeScreen, Never> { get }

    var fullScreenCover: SomeScreen? { get }
    var fullScreenCoverNavigationPath: [SomeScreen] { get }
    var fullScreenCoverDismissPublisher: AnyPublisher<SomeScreen, Never> { get }

    func dismiss()
    func dismissSheet()
    func dismissFullScreenCover()
    func push(_ screen: SomeScreen)
    func pop()
    func popToRoot()
    func present(sheet: SomeScreen)
    func present(fullScreenCover: SomeScreen)
}
