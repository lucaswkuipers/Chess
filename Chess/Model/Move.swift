struct Move {
    let origin: Position
    let destination: Position
}

struct Position: Equatable {
    let row: Int
    let column: Int
}
