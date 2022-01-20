import UIKit

final class GameView: UIView {
    enum Player {
        case top
        case bottom
    }

    private let numberOfRows = 8
    private let numberOfColumns = 8
    private let lightColor: UIColor = .white
    private let darkColor: UIColor = .systemBrown
    private var board: [[SquareSpotButton]] = []
    private var origin: SquareSpotButton?
    private var destination: SquareSpotButton?
    private var playerTurn: Player = .bottom
    private var topPlayerColor: PieceColor = .black
    private var bottomPlayerColor: PieceColor = .white

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

    private let topPlayerConfirmMoveButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("Confirm move", for: .normal)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transform = button.transform.rotated(by: .pi)
        return button
    }()

    private let bottomPlayerConfirmMoveButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("Confirm move", for: .normal)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let topPlayerMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your turn"
        label.isHidden = true
        label.transform = label.transform.rotated(by: .pi)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bottomPlayerMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your turn"
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupViewStyle()
        setupViewHierarchy()
        setupBoardView()
        setupViewActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupData() {
        setupViewConstraints()

        let stringBoard = [["black_rook",
                            "black_knight",
                            "black_bishop",
                            "black_queen",
                            "black_king",
                            "black_bishop",
                            "black_knight",
                            "black_rook"],

                           ["black_pawn",
                            "black_pawn",
                            "black_pawn",
                            "black_pawn",
                            "black_pawn",
                            "black_pawn",
                            "black_pawn",
                            "black_pawn"],

                           [], [], [], [],

                           ["white_pawn",
                            "white_pawn",
                            "white_pawn",
                            "white_pawn",
                            "white_pawn",
                            "white_pawn",
                            "white_pawn",
                            "white_pawn"],

                           ["white_rook",
                            "white_knight",
                            "white_bishop",
                            "white_queen",
                            "white_king",
                            "white_bishop",
                            "white_knight",
                            "white_rook"]]

        let pieces = PieceParser.getPieceBoard(from: stringBoard)

        for row in pieces {
            var rowSquareSpotButton: [SquareSpotButton] = []
            for piece in row {
                let button = SquareSpotButton(color: .purple, with: piece)
                rowSquareSpotButton.append(button)
            }
            board.append(rowSquareSpotButton)
        }

        updateBoard()
    }

    func updateBoard() {
        setupPieces(from: board)
    }

    @objc func didTapBoardSquare(_ sender: SquareSpotButton) {
        if origin == nil {
            guard let originPiece = sender.piece else { return }
            let originPieceColor = originPiece.color

            if playerTurn == .top {
                if originPieceColor != topPlayerColor { return }
            } else {
                if originPieceColor != bottomPlayerColor { return }
            }

            sender.spotState = .origin
            destination?.spotState = .default
            origin = sender
            destination = nil

        } else if origin == sender {
            sender.spotState = .default
            destination?.spotState = .default
            origin = nil
            destination = nil
        } else if destination == nil {
            sender.spotState = .destination
            destination = sender
        } else {
            sender.spotState = .destination
            destination?.spotState = .default
            destination = sender
        }

        if origin != nil && destination != nil {
            switch playerTurn {
            case .top:
                topPlayerConfirmMoveButton.isEnabled = true
                bottomPlayerConfirmMoveButton.isEnabled = false
            case .bottom:
                bottomPlayerConfirmMoveButton.isEnabled = true
                topPlayerConfirmMoveButton.isEnabled = false
            }
        }
    }

    @objc func didTapTopConfirmButton() {
        print("Confirming top player's move")
        print("Bottom player's turn now!")

        // Apply current move
        destination?.piece = origin?.piece
        origin?.piece = nil

        // Reset current move
        origin?.spotState = .default
        destination?.spotState = .default
        origin = nil
        destination = nil
        playerTurn = .bottom
        topPlayerConfirmMoveButton.isEnabled = false
        topPlayerMessageLabel.isHidden = true
        bottomPlayerMessageLabel.isHidden = false
        updateBoard()
    }

    @objc func didTapBottomConfirmButton() {
        print("Confirming bottom player's move")
        print("Top player's turn now!")

        // Apply move
        destination?.piece = origin?.piece
        origin?.piece = nil

        // Reset current move
        origin?.spotState = .default
        destination?.spotState = .default
        origin = nil
        destination = nil
        playerTurn = .top
        bottomPlayerConfirmMoveButton.isEnabled = false
        bottomPlayerMessageLabel.isHidden = true
        topPlayerMessageLabel.isHidden = false
        updateBoard()
    }

    private func setupViewStyle() {
        backgroundColor = .darkGray
    }

    private func setupViewHierarchy() {
        addSubview(boardView)
        addSubview(topPlayerConfirmMoveButton)
        addSubview(bottomPlayerConfirmMoveButton)
        addSubview(topPlayerMessageLabel)
        addSubview(bottomPlayerMessageLabel)
        boardView.addSubview(rowStackView)
    }

    private func setupViewConstraints() {
        let smallestDimension = min(frame.width, frame.height)

        NSLayoutConstraint.activate([
            boardView.centerYAnchor.constraint(equalTo: centerYAnchor),
            boardView.centerXAnchor.constraint(equalTo: centerXAnchor),
            boardView.heightAnchor.constraint(equalToConstant: smallestDimension - 40),
            boardView.widthAnchor.constraint(equalToConstant: smallestDimension - 40),

            topPlayerConfirmMoveButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topPlayerConfirmMoveButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            topPlayerMessageLabel.topAnchor.constraint(equalTo: topPlayerConfirmMoveButton.bottomAnchor, constant: 15),
            topPlayerMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            bottomPlayerConfirmMoveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomPlayerConfirmMoveButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            bottomPlayerMessageLabel.bottomAnchor.constraint(equalTo: bottomPlayerConfirmMoveButton.topAnchor, constant: -15),
            bottomPlayerMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            rowStackView.topAnchor.constraint(equalTo: boardView.topAnchor, constant: 20),
            rowStackView.leftAnchor.constraint(equalTo: boardView.leftAnchor, constant: 20),
            rowStackView.bottomAnchor.constraint(equalTo: boardView.bottomAnchor, constant: -20),
            rowStackView.rightAnchor.constraint(equalTo: boardView.rightAnchor, constant: -20)
        ])
    }

    private func setupViewActions() {
        topPlayerConfirmMoveButton.addTarget(self, action: #selector(didTapTopConfirmButton), for: .touchUpInside)
        bottomPlayerConfirmMoveButton.addTarget(self, action: #selector(didTapBottomConfirmButton), for: .touchUpInside)
    }

    private func setupBoardView() {
        for row in 1...numberOfRows {
            let columnStack = makeColumnStackView()
            for column in 1...numberOfColumns {
                let color = (column + row) % 2 == 0 ? lightColor : darkColor
                let square = makeSquareButton(of: color)
                columnStack.addArrangedSubview(square)
            }
            rowStackView.addArrangedSubview(columnStack)
        }
    }

    private func setupPieces(from board: [[SquareSpotButton]]) {
        for (rowNumber, row) in rowStackView.arrangedSubviews.enumerated() {
            guard let columnStackView = row as? UIStackView else { return }
            for (columnNumber, column) in columnStackView.arrangedSubviews.enumerated() {
                guard let button = column as? SquareSpotButton else { return }
                guard let spot = board[safeIndex: rowNumber]?[safeIndex: columnNumber] else { continue }
                button.piece = spot.piece

                if playerTurn == .top {
                    button.transform = CGAffineTransform(rotationAngle: .pi)
                } else {
                    button.transform = CGAffineTransform(rotationAngle: .zero)
                }
            }
        }
    }

    private func makeColumnStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = .zero
        stack.distribution = .fillEqually
        return stack
    }

    private func makeSquareButton(of color: UIColor) -> SquareSpotButton {
        let button = SquareSpotButton(color: color)
        button.addTarget(self, action: #selector(didTapBoardSquare(_:)), for: .touchUpInside)
        return button
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

    init(color: UIColor, with piece: Piece? = nil) {
        self.defaultColor = color
        self.piece = piece
        self.spotState = .default
        super.init(frame: .zero)
        backgroundColor = defaultColor
    }

    required init?(coder: NSCoder) {
        fatalError("Element not available through coder (only view code)")
    }
}
