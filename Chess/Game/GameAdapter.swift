protocol GameViewProtocol {
    func prepareLayout()
}

protocol GameBrainProtocol {
    func getStartingPieces() -> [[Piece]]
    func didSelect(row: Int, column: Int)
}

final class GameAdapter {
    var didSetupData = false

    var view: GameViewProtocol?
    var controller: GenericViewController?
    var brain: GameBrainProtocol?
}

extension GameAdapter: GenericViewControllerDelegate {
    func viewDidLayoutSubviews() {
        if didSetupData { return }
        view?.prepareLayout()
        didSetupData = true
    }
}
