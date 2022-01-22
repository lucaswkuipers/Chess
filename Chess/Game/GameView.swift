import UIKit

final class GameView: UIView {
    private var board: [[Piece]] = []

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

    func setBoard(from board: [[Piece]]) {
        self.board = board
        renderPieces(from: board)
    }

    @objc func didTapBoardSquare() {
        print("Did tap board square")
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
        for rowNumber in 1...8 {
            rowStackView.addArrangedSubview(makeColumnStackView(for: rowNumber))
        }
    }

    private func renderPieces(from board: [[Piece]]) {
        for (rowNumber, row) in rowStackView.arrangedSubviews.enumerated() {
            guard let columnStackView = row as? UIStackView else { return }
            for (columnNumber, column) in columnStackView.arrangedSubviews.enumerated() {
                guard let button = column as? SquareSpotButton else { return }
                guard let piece = board[safeIndex: rowNumber]?[safeIndex: columnNumber] else { continue }
                button.piece = piece
            }
        }
    }

    private func makeColumnStackView(for rowNumber: Int) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = .zero
        stack.distribution = .fillEqually

        for columnNumber in 1...8 {
            stack.addArrangedSubview(makeSquareButton(row: rowNumber, column: columnNumber))
        }
        return stack
    }

    private func makeSquareButton(row: Int, column: Int) -> SquareSpotButton {
        let button = SquareSpotButton(row: row, column: column)
        button.addTarget(self, action: #selector(didTapBoardSquare), for: .touchUpInside)
        return button
    }
}

extension GameView: GameAdapterView {
    func prepareLayout() {
        setupViewConstraints()
    }
}

final class SquareSpotButton: UIButton {
    enum SpotState {
        case origin
        case destination
        case valid
        case `default`

        var color: UIColor? {
            switch self {
            case .origin:
                return .systemBlue
            case .destination:
                return .systemYellow
            case .valid:
                return .systemGreen
            case .default:
                return nil
            }
        }
    }

    let defaultColor: UIColor
    let row: Int
    let column: Int

    var spotState: SpotState = .default {
        didSet {
            backgroundColor = spotState.color ?? defaultColor
        }
    }

    var piece: Piece? {
        didSet {
            guard let piece = piece else { return }
            setImage(UIImage(named: piece.imageName), for: .normal)
        }
    }

    init(row: Int, column: Int) {
        self.row  = row
        self.column = column
        self.defaultColor = (column + row) % 2 == 0 ? .white : .black
        super.init(frame: .zero)
        backgroundColor = defaultColor
    }

    required init?(coder: NSCoder) {
        fatalError("Init of element not available through coder (you can't use .Xibs / .Storyboards, only init it programmatically)")
    }
}
