enum PieceType: String {
    case king = "king"
    case queen = "queen"
    case rook = "rook"
    case bishop = "bishop"
    case knight = "knight"
    case pawn = "pawn"

    var name: String {
        self.rawValue
    }
}
