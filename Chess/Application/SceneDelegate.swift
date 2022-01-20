import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = GameComposer.makeScreen()
        window?.makeKeyAndVisible()
    }
}

//final class ViewController: UIViewController {
//    private var hasSetupView = false
//
//    override func viewDidLayoutSubviews() {
//        if hasSetupView { return }
//        guard let view = view as? GameView else { return }
//        view.setupData()
//        hasSetupView = true
//    }
//
//    override func loadView() {
//        view = GameView()
//    }
//}
