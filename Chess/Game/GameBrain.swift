protocol GameBrainDelegate {
    func setBoard(to board: [[Spot]])
}

final class GameBrain: GameBrainProtocol {
    var delegate: GameBrainDelegate?
    private var startingBoard = PieceParser.getBoard(from: BoardInitialLayoutVariant.standard.pieces)
    private var board =  PieceParser.getBoard(from: BoardInitialLayoutVariant.standard.pieces)
    private var origin: Position?
    private var destination: Position?

    func getStartingBoard() -> [[Spot]] {
        return startingBoard
    }

    func didSelect(position: Position) {
        if origin == nil {
            if isSpotSelectedEmpty(on: position) { return }
            origin = position
            setValidMoves(with: position)
            setState(.origin, to: position)
        } else {
            if position == origin { return }
            let destinationPiece = getPiece(from: position)
            let originPiece = getPiece(from: origin)

            if destinationPiece?.color == originPiece?.color {
                origin = position
                resetStates()
                setValidMoves(with: position)
                return
            }
            applyChanges(with: position)
        }
    }

    private func isSpotSelectedEmpty(on position: Position) -> Bool {
        return getPiece(from: position) == nil
    }

    private func setValidMoves(with position: Position) {
        // Pawn
        let originPiece = getPiece(from: origin)
        if originPiece?.type == .pawn {
            let validMoves = getValidPawnMoves(from: position)

            for validMove in validMoves {
                print("set valid for ROW: \(validMove.row), COL: \(validMove.column)")
                if getPiece(from: validMove) == nil {
                    setState(.valid, to: validMove)
                } else {
                    setState(.capture, to: validMove)
                }
            }
        return
        }

    }

    private func applyChanges(with position: Position) {
        resetStates()
        destination = position
        setPiece(getPiece(from: origin), to: destination)
        cleanPiece(from: origin)
        resetStates()
        origin = nil
        destination = nil
        printBoard() // log purposes (visualize what should be happening)
    }

    private func setPiece(_ piece: Piece?, to position: Position?) {
        guard let position = position else { return }

        if position.row >= board.count { return }
        guard let row = board[safeIndex: position.row] else { return }
        if position.column >= row.count { return }

        board[position.row][position.column].piece = piece
        delegate?.setBoard(to: board)
    }

    private func setState(_ state: SpotState, to position: Position?) {
        guard let position = position else { return }

        if position.row >= board.count { return }
        guard let row = board[safeIndex: position.row] else { return }
        if position.row >= row.count { return }

        board[position.row][position.column].spotState = state
        delegate?.setBoard(to: board)

    }

    private func getPiece(from position: Position?) -> Piece? {
        guard let position = position else { return nil }
        return board[safeIndex: position.row]?[safeIndex: position.column]?.piece
    }

    private func cleanPiece(from position: Position?) {
        setPiece(nil, to: position)
    }

    private func printBoard() {
        for row in board {
            var line = ""
            for spot in row {
                let pieceName = spot.piece == nil ? "   " : spot.piece!.abbreviation
                line.append("[\(pieceName)]")
            }
            print(line)
        }
    }

    // MARK: - Pieces

    private func getValidPawnMoves(from position: Position) -> [Position] {
        let color = getPiece(from: position)?.color
        var validMoves: [Position] = []

        // White
        if color == .white {
            // Initial two moves
            if position.row == 6 {
                let move = Position(row: 4, column: position.column)
                if getPiece(from: move) == nil {
                    validMoves.append(move) // two moves up
                }
            }

            // Normal front
            let move = Position(row: position.row - 1, column: position.column)
            if getPiece(from: move) == nil {
                validMoves.append(move)
            }

            // Capture (diagonals)
            let leftCaptureMove = Position(row: position.row - 1, column: position.column - 1)
            if getPiece(from: leftCaptureMove)?.color == .black {
                validMoves.append(leftCaptureMove)
            }

            let rightCaptureMove = Position(row: position.row - 1, column: position.column + 1)
            if getPiece(from: rightCaptureMove)?.color == .black {
                validMoves.append(rightCaptureMove)
            }
        }
        return validMoves
    }

    private func resetStates() {
        for (rowIndex, row) in board.enumerated() {
            for (spotIndex, _) in row.enumerated() {
                board[rowIndex][spotIndex].spotState = .default
            }
        }
    }
}
