final class GameBrain: GameBrainProtocol {

    var pieces: [[Piece]] = []

    func getStartingPieces() -> [[Piece]] {
        return pieces
    }

    func didSelect(row: Int, column: Int) {
        print("Did select row: \(row), column: \(column)")
    }
}
