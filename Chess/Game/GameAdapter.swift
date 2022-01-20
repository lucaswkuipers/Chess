final class GameAdapter {
    var didSetupData = false
    var view: GameView?
    var controller: GenericViewController?
}

extension GameAdapter: GenericViewControllerDelegate {
    func viewDidLayoutSubviews() {
        if didSetupData { return }
        view?.setupData()
        didSetupData = true
    }
}
