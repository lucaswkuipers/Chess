protocol GameViewProtocol {
    func prepareLayout()
    func setBoard(to board: [[Spot]])
    func rotateBoard()
}

protocol GameBrainProtocol {
    func getStartingBoard() -> [[Spot]]
    func getStartingPlayer() -> Player
    func didSelect(position: Position)
}

final class GameAdapter {
    var didPrepareLayout = false

    var view: GameViewProtocol?
    var viewController: GenericViewController?
    var coordinator: GameCoordinatorProtocol?
    var brain: GameBrainProtocol?

    func prepareLayout() {
        if didPrepareLayout { return }
        view?.prepareLayout()
        didPrepareLayout = true
    }

    func setupBoard() {
        guard let startingBoard = brain?.getStartingBoard() else { return }
        let startingPlayer = brain?.getStartingPlayer()
        view?.setBoard(to: startingBoard)
        if startingPlayer == .top {
            view?.rotateBoard()
        }
    }
}

extension GameAdapter: GenericViewControllerDelegate {
    func viewDidLayoutSubviews() {
        prepareLayout()
    }

    func viewWillAppear() {
        viewController?.navigationController?.isNavigationBarHidden = true
        setupBoard()
    }

    func viewWillDisappear() {
        viewController?.navigationController?.isNavigationBarHidden = false
    }
}

extension GameAdapter: GameViewDelegate {
    func didTapSettingsButton() {
        viewController?.navigationController?.pushViewController(SettingsComposer.makeScene(), animated: true)
        print("DID tap stuff")
    }

    func didSelect(position: Position) {
        brain?.didSelect(position: position)
    }
}

extension GameAdapter: GameBrainDelegate {
    func setBoard(to board: [[Spot]]) {
        view?.setBoard(to: board)
    }

    func rotateBoard() {
        view?.rotateBoard()
    }
}

protocol GameCoordinatorProtocol {
    func goToSettings()
}

struct GameCoordinator: GameCoordinatorProtocol {
    func goToSettings() {
        print("Going to settings!")
    }
}
