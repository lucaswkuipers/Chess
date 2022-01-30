struct PieceParser {
    static func getBoard(from stringBoard: [[String]]) -> [[Spot]] {
        var board: [[Spot]] = []
        for row in stringBoard {
            var spotRow: [Spot] = []
            for stringPiece in row {
                let separatedString = stringPiece.split(separator: "_").map(String.init)
                let pieceColorRawValue = separatedString.first ?? ""
                let pieceTypeRawValue = separatedString.last ?? ""
                let pieceColor = PieceColor(rawValue: pieceColorRawValue)
                let pieceType = PieceType(rawValue: pieceTypeRawValue)
                let piece = makePiece(type: pieceType, color: pieceColor)
                let spot = Spot(spotState: .default, piece: piece)
                spotRow.append(spot)
            }
            board.append(spotRow)
        }
        return board
    }

    private static func makePiece(type: PieceType?, color: PieceColor?) -> Piece? {
        guard let type = type,
              let color = color else { return nil }

        return Piece(type: type, color: color)
    }
}
