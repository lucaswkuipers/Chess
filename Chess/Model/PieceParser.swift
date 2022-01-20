struct PieceParser {
    static func getPieceBoard(from stringBoard: [[String]]) -> [[Piece]] {
        var pieceBoard: [[Piece]] = []
        for row in stringBoard {
            var pieceRow: [Piece] = []
            for stringPiece in row {
                let separatedString = stringPiece.split(separator: "_").map(String.init)

                guard let pieceColorRawValue = separatedString.first,
                      let pieceTypeRawValue = separatedString.last,
                      let pieceColor = PieceColor(rawValue: pieceColorRawValue),
                      let pieceType = PieceType(rawValue: pieceTypeRawValue) else { continue }

                let piece = Piece(type: pieceType, color: pieceColor)
                pieceRow.append(piece)
            }
            pieceBoard.append(pieceRow)
        }
        return pieceBoard
    }
}
