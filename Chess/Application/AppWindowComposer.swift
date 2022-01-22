import UIKit

final class AppWindowComposer {
    static func makeWindow(from scene: UIScene) -> UIWindow? {
        guard let windowScene = (scene as? UIWindowScene) else { return nil }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = GameComposer.makeScreen()
        window.makeKeyAndVisible()
        return window
    }
}
