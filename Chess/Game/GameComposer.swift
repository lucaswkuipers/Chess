import UIKit

struct GameComposer {
    static func makeScreen() -> UIViewController {
        let view = GameView()
        let viewController = GenericViewController(with: view)
        let adapter = GameAdapter()
        let brain = GameBrain()

        adapter.brain = brain
        adapter.view = view

        view.delegate = adapter
        viewController.delegate = adapter

        return viewController
    }
}
