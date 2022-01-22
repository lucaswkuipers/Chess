protocol GameViewProtocol {
    func prepareLayout()
    func setBoard(to board: [[Piece]])
}

protocol GameBrainProtocol {
    func getStartingPieces() -> [[Piece]]
    func didSelect(position: Position)
}

final class GameAdapter {
    var didPrepareLayout = false

    var view: GameViewProtocol?
    var controller: GenericViewController?
    var brain: GameBrainProtocol?

    func prepareLayout() {
        if didPrepareLayout { return }
        view?.prepareLayout()
        didPrepareLayout = true
    }

    func setupBoard() {
        guard let startingPieces = brain?.getStartingPieces() else { return }
        view?.setBoard(to: startingPieces)
    }
}

extension GameAdapter: GenericViewControllerDelegate {
    func viewDidLayoutSubviews() {
        prepareLayout()
    }

    func viewWillAppear() {
        setupBoard()
    }
}

extension GameAdapter: GameViewDelegate {
    func didSelect(position: Position) {
        brain?.didSelect(position: position)
    }
}
