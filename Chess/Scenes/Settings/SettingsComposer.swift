import UIKit

struct SettingsComposer {
    static func makeScene() -> UIViewController {
        let view = SettingsView()
        let adapter = SettingsAdapter()
        let viewController = GenericViewController(with: view)

        adapter.view = view
        adapter.viewController = viewController
        viewController.delegate = adapter

        return viewController
    }
}
