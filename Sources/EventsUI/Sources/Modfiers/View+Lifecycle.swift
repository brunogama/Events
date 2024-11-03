import EventsCommons
import EventsDomain
import SwiftUI

/// A view modifier that allows to execute code on the lifecycle of a view.
/// Usage:
/// ```
/// struct ContentView: View {
///    var body: some View {
///        VStack {
///            Text("Hello, World!")
///                .font(.largeTitle)
///        }
///        .onLifecycle(
///            onLoad: {
///                print("View did load")
///            },
///            onAppear: {
///                print("View will appear")
///            },
///            onDisappear: {
///                print("View will disappear")
///            }
///        )
///    }
///}
/// ```

extension View {
    func onLoad(_ action: @escaping () -> Void) -> some View {
        self.modifier(OnLoadModifier(action: action))
    }

    func onAppearOnce(_ action: @escaping () -> Void) -> some View {
        self.modifier(OnAppearModifier(action: action))
    }

    func onDisappearOnce(_ action: @escaping () -> Void) -> some View {
        self.modifier(OnDisappearModifier(action: action))
    }
}
