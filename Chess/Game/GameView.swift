import UIKit

protocol GameViewDelegate: AnyObject {
    func didSelect(position: Position)
}

final class GameView: UIView {
    weak var delegate: GameViewDelegate?
    private var board: [[Spot]] = []

    private let boardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .brown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let rowStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = .zero
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init() {
        super.init(frame: .zero)
        setupViewStyle()
        setupViewHierarchy()
        setupBoardView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func didTapBoardSpot(_ sender: SpotButton) {
        delegate?.didSelect(position: sender.position)
    }

    private func setupViewStyle() {
        backgroundColor = .darkGray
    }

    private func setupViewHierarchy() {
        addSubview(boardView)
        boardView.addSubview(rowStackView)
    }

    private func setupViewConstraints() {
        let smallestDimension = min(frame.width, frame.height)

        NSLayoutConstraint.activate([
            boardView.centerYAnchor.constraint(equalTo: centerYAnchor),
            boardView.centerXAnchor.constraint(equalTo: centerXAnchor),
            boardView.heightAnchor.constraint(equalToConstant: smallestDimension - 40),
            boardView.widthAnchor.constraint(equalToConstant: smallestDimension - 40),

            rowStackView.topAnchor.constraint(equalTo: boardView.topAnchor, constant: 20),
            rowStackView.leftAnchor.constraint(equalTo: boardView.leftAnchor, constant: 20),
            rowStackView.bottomAnchor.constraint(equalTo: boardView.bottomAnchor, constant: -20),
            rowStackView.rightAnchor.constraint(equalTo: boardView.rightAnchor, constant: -20)
        ])
    }

    private func setupBoardView() {
        for rowNumber in 0..<8 {
            rowStackView.addArrangedSubview(makeColumnStackView(for: rowNumber))
        }
    }

    private func renderPieces() {
        for (rowNumber, row) in rowStackView.arrangedSubviews.enumerated() {
            guard let spotStackView = row as? UIStackView else { return }
            for (columnNumber, column) in spotStackView.arrangedSubviews.enumerated() {
                guard let button = column as? SpotButton,
                      let spot = board[safeIndex: rowNumber]?[safeIndex: columnNumber] else { continue }
                button.piece = spot.piece
                button.spotState = spot.spotState
            }
        }
    }

    private func makeColumnStackView(for rowNumber: Int) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = .zero
        stack.distribution = .fillEqually

        for columnNumber in 0..<8 {
            stack.addArrangedSubview(makeSpotButton(row: rowNumber, column: columnNumber))
        }
        return stack
    }

    private func makeSpotButton(row: Int, column: Int) -> SpotButton {
        let button = SpotButton(on: Position(row: row, column: column))
        button.addTarget(self, action: #selector(didTapBoardSpot(_:)), for: .touchUpInside)
        return button
    }
}

extension GameView: GameViewProtocol {
    func rotateBoard() {
        for row in rowStackView.arrangedSubviews {
            guard let spotStackView = row as? UIStackView else { return }
            for column in spotStackView.arrangedSubviews {
                guard let button = column as? SpotButton else { continue }
                button.rotate()
            }
        }
    }

    func setBoard(to board: [[Spot]]) {
        self.board = board
        renderPieces()
    }

    func prepareLayout() {
        setupViewConstraints()
    }
}
