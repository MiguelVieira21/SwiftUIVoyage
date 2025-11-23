import Combine
import Observation

@MainActor
public final class ParentRouter<SomeScreen: Hashable & Identifiable>: ParentRouterProtocol {
    @Published public var selectedTab: SomeScreen

    public init(selectedTab: SomeScreen) {
        self.selectedTab = selectedTab
    }
    
    public func childRouter(for tab: SomeScreen) -> ChildRouter<ParentRouter> {
        ChildRouter(correspondingTab: tab, parent: self)
    }
}
