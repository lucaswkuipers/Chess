final class GameBrain: GameBrainProtocol {
    private let allPositions: [Position] = []

    private var startingPieces = PieceParser.getPieceBoard(from: BoardInitialLayoutVariant.standard.pieces)
    private var pieces =  PieceParser.getPieceBoard(from: BoardInitialLayoutVariant.standard.pieces)
    private var playerTurn: Player = .bottom
    private var validPositions: [Position] = []

    init() {
//        allPositions = (0..<8).map { row in (0..<8).map { column in Position(row: row, column: column)}}
    }

    func getStartingPieces() -> [[Piece]] {
        return startingPieces
    }

    func didSelect(position: Position) {
        print("GameBrain: Did tap board spot of row: \(position.row), column: \(position.column)")

        // Validate selection
        // Make selection if valid
        // Make move if selection is second
        // Check if game is over
        // Update visuals
    }

    func updateValidPositions() {

    }
}
