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
            if getPiece(from: position) == nil { return }
            origin = position
        } else {
            destination = position
            let piece = getPiece(from: origin)
            print("Piece set to: \(piece?.type.rawValue)")
            setPiece(piece, to: destination)
            cleanPiece(from: origin)
            origin = nil
            destination = nil
            printBoard()
        }
    }

    private func setPiece(_ piece: Piece?, to position: Position?) {
        guard let position = position else { return }

        if position.row >= board.count { return }
        if position.column >= board[position.row].count { return }

        board[position.row][position.column].piece = piece
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
}
