protocol GameViewProtocol {
    func prepareLayout()
    func setBoard(to board: [[Spot]])
}

protocol GameBrainProtocol {
    func getStartingBoard() -> [[Spot]]
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
        guard let startingBoard = brain?.getStartingBoard() else { return }
        view?.setBoard(to: startingBoard)
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

extension GameAdapter: GameBrainDelegate {
    func setBoard(to board: [[Spot]]) {
        view?.setBoard(to: board)
    }
}
