struct PieceParser {
    static func getBoard(from stringBoard: [[String]]) -> [[Spot]] {
        var board: [[Spot]] = []
        for row in stringBoard {
            var spotRow: [Spot] = []
            for stringPiece in row {
                let separatedString = stringPiece.split(separator: "_").map(String.init)
                guard let pieceColorRawValue = separatedString.first,
                      let pieceTypeRawValue = separatedString.last,
                      let pieceColor = PieceColor(rawValue: pieceColorRawValue),
                      let pieceType = PieceType(rawValue: pieceTypeRawValue) else { continue }
                let piece = Piece(type: pieceType, color: pieceColor)
                let spot = Spot(spotState: .default, piece: piece)
                spotRow.append(spot)
            }
            board.append(spotRow)
        }
        return board
    }
}
