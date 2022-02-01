import UIKit

struct GameComposer {
    static func makeScene() -> UIViewController {
        let view = GameView()
        let viewController = GenericViewController(with: view)
        let adapter = GameAdapter()
        let brain = GameBrain()

        adapter.brain = brain
        adapter.view = view
        adapter.viewController = viewController

        view.delegate = adapter
        viewController.delegate = adapter
        brain.delegate = adapter

        return viewController
    }
}
