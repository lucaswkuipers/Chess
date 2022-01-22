protocol GameAdapterView {
    func prepareLayout()
}

final class GameAdapter {
    var didSetupData = false
    var view: GameAdapterView?
    var controller: GenericViewController?
}

extension GameAdapter: GenericViewControllerDelegate {
    func viewDidLayoutSubviews() {
        if didSetupData { return }
        view?.prepareLayout()
        didSetupData = true
    }
}
