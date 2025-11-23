import Combine

@MainActor
public protocol ParentRouterProtocol: AnyObject, ObservableObject {
    associatedtype ChildRouterType: ChildRouterProtocol where ChildRouterType.SomeScreen == SomeScreen
    associatedtype SomeScreen: Hashable & Identifiable

    var selectedTab: SomeScreen { get set }

    func childRouter(for tab: SomeScreen) -> ChildRouterType
}
