import Combine

@MainActor
public final class ChildRouter<Parent: ParentRouterProtocol>: ChildRouterProtocol {
    public typealias SomeScreen = Parent.SomeScreen
    private weak var parent: Parent?
    public private(set) var sheetDismissPublisher: AnyPublisher<SomeScreen, Never>
    public private(set) var fullScreenCoverDismissPublisher: AnyPublisher<SomeScreen, Never>
    public private(set) var sheetDismissPassthrough: PassthroughSubject<SomeScreen, Never> = .init()
    public private(set) var fullScreenCoverDismissPassthrough: PassthroughSubject<SomeScreen, Never> = .init()

    @Published public var navigationPath: [SomeScreen] = []

    @Published public var sheet: SomeScreen? {
        didSet {
            if sheet == nil {
                if let oldValue {
                    sheetDismissPassthrough.send(oldValue)
                }
                sheetNavigationPath.removeAll()
            }
        }
    }
    @Published public var sheetNavigationPath: [SomeScreen] = []

    @Published public var fullScreenCover: SomeScreen? {
        didSet {
            if fullScreenCover == nil {
                if let oldValue {
                    fullScreenCoverDismissPassthrough.send(oldValue)
                }
                fullScreenCoverNavigationPath.removeAll()
            }
        }
    }
    @Published public var fullScreenCoverNavigationPath: [SomeScreen] = []

    public let correspondingTab: SomeScreen

    public var isActiveTab: Bool {
        correspondingTab == parent?.selectedTab
    }
    
    public init(correspondingTab: SomeScreen, parent: Parent) {
        self.correspondingTab = correspondingTab
        self.parent = parent
        sheetDismissPublisher = sheetDismissPassthrough.eraseToAnyPublisher()
        fullScreenCoverDismissPublisher = fullScreenCoverDismissPassthrough.eraseToAnyPublisher()
    }
    
    public func push(_ screen: SomeScreen) {
        if sheet != nil {
            sheetNavigationPath.append(screen)
        } else if fullScreenCover != nil {
            fullScreenCoverNavigationPath.append(screen)
        } else {
            navigationPath.append(screen)
        }
    }
    
    public func pop() {
        if sheet != nil {
            sheetNavigationPath.removeLast()
        } else if fullScreenCover != nil {
            fullScreenCoverNavigationPath.removeLast()
        } else {
            navigationPath.removeLast()
        }
    }
    
    public func popToRoot() {
        if sheet != nil {
            sheetNavigationPath.removeAll()
        } else if fullScreenCover != nil {
            fullScreenCoverNavigationPath.removeAll()
        } else {
            navigationPath.removeAll()
        }
    }
    
    public func present(sheet: SomeScreen) {
        guard self.sheet == nil else {
            print("Attempted to present a sheet while another one's already present. Ignoring")
            return
        }
        
        self.sheet = sheet
    }
    
    public func present(fullScreenCover: SomeScreen) {
        guard self.fullScreenCover == nil else {
            print("Attempted to present a fullScreenCover while another one's already present. Ignoring")
            return
        }
        
        self.fullScreenCover = fullScreenCover
    }
    
    public func dismiss() {
        if sheet != nil {
            dismissSheet()
        } else if fullScreenCover != nil {
            dismissFullScreenCover()
        } else {
            print("Nothing to dismiss!")
        }
    }
    
    public func dismissSheet() {
        sheet = nil
    }
    
    public func dismissFullScreenCover() {
        fullScreenCover = nil
    }
}

