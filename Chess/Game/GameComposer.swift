import UIKit

struct GameComposer {
    static func makeScreen() -> UIViewController {
        let view = GameView()
        let viewController = GenericViewController(with: view)
        let adapter = GameAdapter()

        adapter.view = view
        viewController.delegate = adapter

        return viewController
    }
}
