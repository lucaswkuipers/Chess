final class GameBrain: GameBrainProtocol {
    private var startingPieces = PieceParser.getPieceBoard(from: BoardInitialLayoutVariant.standard.pieces)
    private var pieces =  PieceParser.getPieceBoard(from: BoardInitialLayoutVariant.standard.pieces)

    func getStartingPieces() -> [[Piece]] {
        return startingPieces
    }

    func didSelect(position: Position) {
        print("GameBrain: Did tap board spot of row: \(position.row), column: \(position.column)")
    }
}
