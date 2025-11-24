# SwiftUI-Voyage

A lightweight, open-source navigation framework for SwiftUI. Designed to be minimal, testable, and easy to integrate into any project.

## Features:
Navigate by injecting a Navigator object on your ViewModels / ViewStore allowing you to inject mocks and keeping navigation testable
```swift
MyView(store: MyViewStore(navigator: navigator))
```

### __OR__

Simply leverage the power of @EnvironmentObject and navigate directly on the view. By default, every view has direct access to a Navigator object just by 

```swift
typealias Navigator = ChildRouter<ParentRouter<Screen>> // Optional, but recommended. Easier to write but needs to be done by the client to specialize the Screen generic.

struct MyView: View {
  @EnvironmentObject private var navigator: Navigator
}
```

`Navigator` allows you to navigate to any given Screen (defined by you, more info below 👇) as well as keep an eye out for current presented sheet, observe dismissals, etc
<details>
  <summary>Show protocol definition</summary>
  
```swift
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
```
</details>


## Usage:
```swift
.package(url: "https://github.com/MiguelVieira21/SwiftUIVoyage.git", from: "1.0.0")
```

### Create an enum representing your views (must conform to Hashable & Identifiable).
<details>
  <summary>Example</summary>
  
```swift
enum Screen: Hashable, Identifiable {
    case listView
    case detailView(Landmark)
    case signIn
}
```

</details>

### Create your ViewFactory/Provider
- Must conform to ViewFactoryProtocol
- `view(for screen: Screen, navigator: Navigator)` function will be called automatically by the framework as needed. It gives you back a navigator object if you want to inject it to a ViewModel / ViewStore / etc.

<details>
  <summary>Example</summary>

```swift
typealias Navigator = any NavigatorProtocol<Screen>

final class ViewFactory: ViewFactoryProtocol {
    @ViewBuilder
    func view(for screen: Screen, navigator: Navigator) -> some View {
        switch screen {
            case .listView:
                LandmarksListView(store: LandmarksListStore(navigator: navigator))
        (...)
```

</details>

Finally, set ``AppRootView`` as your starting view, injecting the necessary properties:
```swift
import SwiftUIVoyage

@main
struct SwiftUI_MVIApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView(
                router: ParentRouter(selectedTab: Screen.listView),
                viewFactory: ViewFactory(),
                tabItems: [.listView, .settingsView]
            )
        }
    }
}
```

Or, if you don't want multiple tabs, just replace `tabItems` with `rootScreen`

That's all!
