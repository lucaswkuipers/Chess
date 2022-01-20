struct Piece {
    let type: PieceType
    let color: PieceColor

    var imageName: String {
        color.name + "_" + type.name
    }
}
