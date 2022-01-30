struct Piece {
    let type: PieceType
    let color: PieceColor

    var imageName: String {
        color.name + "_" + type.name
    }

    var abbreviation: String {
        color.name.first!.uppercased() + "_" + type.name.first!.uppercased()
    }
}
