import UIKit

final class AppWindowComposer {
    static func makeWindow(from scene: UIScene) -> UIWindow? {
        guard let windowScene = (scene as? UIWindowScene) else { return nil }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: GameComposer.makeScene())
        window.makeKeyAndVisible()
        return window
    }
}
