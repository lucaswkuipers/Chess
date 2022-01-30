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
            // First selection: Origin
            if getPiece(from: position) == nil { return }
            origin = position

            // Pawn
            let originPiece = getPiece(from: origin)
            if originPiece?.type == .pawn {
                let validMoves = getValidPawnMoves(from: position)

                for validMove in validMoves {
                    print("set valid for ROW: \(validMove.row), COL: \(validMove.column)")
                    setState(.valid, to: validMove)
                }
            }
        } else {
            // Second selection: Destination

            // Validation
            let destinationPiece = getPiece(from: position)
            let originPiece = getPiece(from: origin)

            if destinationPiece?.color == originPiece?.color {
                origin = position
                resetStates()

                // Pawn
                let originPiece = getPiece(from: origin)
                if originPiece?.type == .pawn {
                    let validMoves = getValidPawnMoves(from: position)

                    for validMove in validMoves {
                        print("set valid for ROW: \(validMove.row), COL: \(validMove.column)")
                        setState(.valid, to: validMove)
                    }
                return
                }
            }

            // Apply changes
            resetStates()
            destination = position
            setPiece(getPiece(from: origin), to: destination)
            cleanPiece(from: origin)
            resetStates()
            origin = nil
            destination = nil
            printBoard() // log purposes (visualize what should be happening)
        }
    }

    private func setPiece(_ piece: Piece?, to position: Position?) {
        guard let position = position else { return }

        if position.row >= board.count { return }
        if position.column >= board[position.row].count { return }

        board[position.row][position.column].piece = piece
        delegate?.setBoard(to: board)
    }

    private func setState(_ state: SpotState, to position: Position?) {
        guard let position = position else { return }

        if position.row >= board.count { return }
        if position.column >= board[position.row].count { return }

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
