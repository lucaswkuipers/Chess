import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = GameViewComposer.makeScene()
        window?.makeKeyAndVisible()
    }
}

struct GameViewComposer {
    static func makeScene() -> UIViewController {
        let view = GameView()
        let viewController = GenericViewController(with: view)
        return viewController
    }
}

final class GameView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .blue
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

final class GenericViewController: UIViewController {
    private var screen: UIView?

    init(with view: UIView) {
        screen = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadView() {
        view = screen
    }
}
