struct Spot {
    let position: Position = .init(row: -1, column: -1)
    var spotState: SpotState = .default
    var piece: Piece?
}
