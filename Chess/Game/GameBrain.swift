protocol GameBrainDelegate {
    func setBoard(to board: [[Spot]])
}

final class GameBrain: GameBrainProtocol {
    var delegate: GameBrainDelegate?
    private var startingBoard = PieceParser.getBoard(from: BoardInitialLayoutVariant.standard.pieces)
    private var board =  PieceParser.getBoard(from: BoardInitialLayoutVariant.standard.pieces)
    private var numberOfRows: Int {
        board.count
    }
    private var numberOfColumns: Int {
        board.first?.count ?? 0
    }
    private var origin: Position?
    private var destination: Position?

    func getStartingBoard() -> [[Spot]] {
        return startingBoard
    }

    func didSelect(position: Position) {
        if origin == nil {
            if isSpotSelectedEmpty(on: position) { return }
            origin = position
            setValidMoves(with: position)
            setState(.origin, to: position)
        } else {
            if position == origin { return }
            let destinationPiece = getPiece(from: position)
            let originPiece = getPiece(from: origin)

            if destinationPiece?.color == originPiece?.color {
                origin = position
                resetStates()
                setValidMoves(with: position)
                return
            }
            applyChanges(with: position)
        }
    }

    private func isSpotSelectedEmpty(on position: Position) -> Bool {
        return getPiece(from: position) == nil
    }

    private func setValidMoves(with position: Position) {
        guard let originPiece = getPiece(from: origin) else { return }
        var validMoves: [Position] = []
        switch originPiece.type {
        case .king:
            validMoves = getValidKingMoves(from: position)
        case .queen:
            validMoves = getValidQueenMoves(from: position)
        case .rook:
            validMoves = getValidRookMoves(from: position)
        case .bishop:
            validMoves = getValidBishopMoves(from: position)
        case .knight:
            validMoves = [] // getValidKnightMoves(from: position)
        case .pawn:
            validMoves = getValidPawnMoves(from: position)
        }

        setValidMovesState(for: validMoves)
    }

    private func setValidMovesState(for moves: [Position]) {
        for move in moves {
            if getPiece(from: move) == nil {
                setState(.valid, to: move)
            } else {
                setState(.capture, to: move)
            }
        }
    }

    private func applyChanges(with position: Position) {
        resetStates()
        destination = position
        setPiece(getPiece(from: origin), to: destination)
        cleanPiece(from: origin)
        resetStates()
        origin = nil
        destination = nil
        printBoard() // log purposes (visualize what should be happening)
    }

    private func setPiece(_ piece: Piece?, to position: Position?) {
        guard let position = position else { return }

        if position.row >= board.count { return }
        guard let row = board[safeIndex: position.row] else { return }
        if position.column >= row.count { return }

        board[position.row][position.column].piece = piece
        delegate?.setBoard(to: board)
    }

    private func setState(_ state: SpotState, to position: Position?) {
        guard let position = position else { return }

        if position.row >= board.count { return }
        guard let row = board[safeIndex: position.row] else { return }
        if position.row >= row.count { return }

        board[position.row][position.column].spotState = state
        delegate?.setBoard(to: board)

    }

    private func getPiece(from position: Position?) -> Piece? {
        guard let position = position else { return nil }
        return board[safeIndex: position.row]?[safeIndex: position.column]?.piece
    }

    private func cleanPiece(from position: Position?) {
        setPiece(nil, to: position)
    }

    private func printBoard() {
        for row in board {
            var line = ""
            for spot in row {
                let pieceName = spot.piece == nil ? "   " : spot.piece!.abbreviation
                line.append("[\(pieceName)]")
            }
            print(line)
        }
    }

    // MARK: - Pieces

    private func getValidKingMoves(from position: Position) -> [Position] {
        let color = getPiece(from: position)?.color
        var validMoves: [Position] = []

        // White
        if color == .white {
            // Front
            let frontMove = Position(row: position.row - 1, column: position.column)
            if getPiece(from: frontMove)?.color != color {
                validMoves.append(frontMove)
            }
            // Back
            let backMove = Position(row: position.row + 1, column: position.column)
            if getPiece(from: backMove)?.color != color {
                validMoves.append(backMove)
            }
            // Left
            let leftMove = Position(row: position.row, column: position.column - 1)
            if getPiece(from: leftMove)?.color != color {
                validMoves.append(leftMove)
            }
            // Right
            let rightMove = Position(row: position.row, column: position.column + 1)
            if getPiece(from: rightMove)?.color != color {
                validMoves.append(rightMove)
            }
            // Upper-Left
            let upperLeftMove = Position(row: position.row - 1, column: position.column - 1)
            if getPiece(from: upperLeftMove)?.color != color {
                validMoves.append(upperLeftMove)
            }
            // Upper-Right
            let upperRightMove = Position(row: position.row - 1, column: position.column + 1)
            if getPiece(from: upperRightMove)?.color != color {
                validMoves.append(upperRightMove)
            }
            // Lower-Left
            let lowerLeftMove = Position(row: position.row + 1, column: position.column - 1)
            if getPiece(from: lowerLeftMove)?.color != color {
                validMoves.append(lowerLeftMove)
            }
            // Lower-Right
            let lowerRightMove = Position(row: position.row + 1, column: position.column + 1)
            if getPiece(from: lowerRightMove)?.color != color {
                validMoves.append(lowerRightMove)
            }
        }
        return validMoves
    }

    private func getValidQueenMoves(from position: Position) -> [Position] {
        let color = getPiece(from: position)?.color
        var validMoves: [Position] = []

        // White
        if color == .white {
            // Up
            // Check if not at the top
            if position.row > 0 {
                for rowNumber in (0...position.row - 1).reversed() {
                    let move = Position(row: rowNumber, column: position.column)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }
                }
            }
            // Down
            // Check if not at the bottom
            if position.row < numberOfRows - 1 {
                for rowNumber in position.row + 1...board.count - 1 {
                    let move = Position(row: rowNumber, column: position.column)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }
                }
            }

            // Left
            // Check if not at border left
            if position.column > 0 {
                for columnNumber in (0...position.column - 1).reversed() {
                    let move = Position(row: position.row, column: columnNumber)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }
                }
            }

            // Right
            // Check if not at border right
            if position.column < numberOfColumns - 1 {
                for columnNumber in position.column + 1...numberOfColumns - 1 {
                    let move = Position(row: position.row, column: columnNumber)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }
                }
            }

            // Up left
            // Check if not at upper corner left
            if position.row > 0 && position.column > 0 {
                var rowNumber = position.row - 1
                var columnNumber = position.column - 1

                while rowNumber >= 0 && columnNumber >= 0 {
                    let move = Position(row: rowNumber, column: columnNumber)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }

                    rowNumber -= 1
                    columnNumber -= 1
                }
            }

            // Up right
            // Check if not at upper corner right
            if position.row > 0 && position.column < numberOfColumns {
                var rowNumber = position.row - 1
                var columnNumber = position.column + 1

                while rowNumber >= 0 && columnNumber < numberOfColumns {
                    let move = Position(row: rowNumber, column: columnNumber)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }

                    rowNumber -= 1
                    columnNumber += 1
                }
            }

            // Lower left
            // Check if not at lower corner left
            if position.row < numberOfRows - 1 && position.column > 0 {
                var rowNumber = position.row + 1
                var columnNumber = position.column - 1

                while rowNumber < numberOfRows && columnNumber >= 0 {
                    let move = Position(row: rowNumber, column: columnNumber)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }

                    rowNumber += 1
                    columnNumber -= 1
                }
            }

            // Lower right
            // Check if not at lower corner right
            if position.row < numberOfRows - 1 && position.column < numberOfColumns - 1 {
                var rowNumber = position.row + 1
                var columnNumber = position.column + 1

                while rowNumber < numberOfRows && columnNumber < numberOfColumns {
                    let move = Position(row: rowNumber, column: columnNumber)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }

                    rowNumber += 1
                    columnNumber += 1
                }
            }
        }
        return validMoves
    }

    private func getValidRookMoves(from position: Position) -> [Position] {
        let color = getPiece(from: position)?.color
        var validMoves: [Position] = []

        // White
        if color == .white {
            // Up
            // Check if not at the top
            if position.row > 0 {
                for rowNumber in (0...position.row - 1).reversed() {
                    let move = Position(row: rowNumber, column: position.column)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }
                }
            }
            // Down
            // Check if not at the bottom
            if position.row < numberOfRows - 1 {
                for rowNumber in position.row + 1...board.count - 1 {
                    let move = Position(row: rowNumber, column: position.column)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }
                }
            }

            // Left
            // Check if not at border left
            if position.column > 0 {
                for columnNumber in (0...position.column - 1).reversed() {
                    let move = Position(row: position.row, column: columnNumber)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }
                }
            }

            // Right
            // Check if not at border right
            if position.column < numberOfColumns - 1 {
                for columnNumber in position.column + 1...numberOfColumns - 1 {
                    let move = Position(row: position.row, column: columnNumber)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }
                }
            }
        }
        return validMoves
    }

    private func getValidBishopMoves(from position: Position) -> [Position] {
        let color = getPiece(from: position)?.color
        var validMoves: [Position] = []

        // White
        if color == .white {
            // Up left
            // Check if not at upper corner left
            if position.row > 0 && position.column > 0 {
                var rowNumber = position.row - 1
                var columnNumber = position.column - 1

                while rowNumber >= 0 && columnNumber >= 0 {
                    let move = Position(row: rowNumber, column: columnNumber)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }

                    rowNumber -= 1
                    columnNumber -= 1
                }
            }

            // Up right
            // Check if not at upper corner right
            if position.row > 0 && position.column < numberOfColumns {
                var rowNumber = position.row - 1
                var columnNumber = position.column + 1

                while rowNumber >= 0 && columnNumber < numberOfColumns {
                    let move = Position(row: rowNumber, column: columnNumber)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }

                    rowNumber -= 1
                    columnNumber += 1
                }
            }

            // Lower left
            // Check if not at lower corner left
            if position.row < numberOfRows - 1 && position.column > 0 {
                var rowNumber = position.row + 1
                var columnNumber = position.column - 1

                while rowNumber < numberOfRows && columnNumber >= 0 {
                    let move = Position(row: rowNumber, column: columnNumber)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }

                    rowNumber += 1
                    columnNumber -= 1
                }
            }

            // Lower right
            // Check if not at lower corner right
            if position.row < numberOfRows - 1 && position.column < numberOfColumns - 1 {
                var rowNumber = position.row + 1
                var columnNumber = position.column + 1

                while rowNumber < numberOfRows && columnNumber < numberOfColumns {
                    let move = Position(row: rowNumber, column: columnNumber)
                    if getPiece(from: move)?.color == color { break }
                    validMoves.append(move)
                    if getPiece(from: move) != nil { break }

                    rowNumber += 1
                    columnNumber += 1
                }
            }
        }
        return validMoves
    }

    private func getValidPawnMoves(from position: Position) -> [Position] {
        let color = getPiece(from: position)?.color
        var validMoves: [Position] = []

        // White
        if color == .white {
            // Initial two moves
            if position.row == 6 {
                let move = Position(row: 4, column: position.column)
                if getPiece(from: move)?.color != color {
                    let previousPosition = Position(row: 5, column: position.column)
                    if getPiece(from: previousPosition) == nil {
                        validMoves.append(move) // two moves up
                    }
                }
            }

            // Normal front
            let move = Position(row: position.row - 1, column: position.column)
            if getPiece(from: move) == nil {
                validMoves.append(move)
            }

            // Capture (diagonals)
            let leftCaptureMove = Position(row: position.row - 1, column: position.column - 1)
            if getPiece(from: leftCaptureMove)?.color == .black {
                validMoves.append(leftCaptureMove)
            }

            let rightCaptureMove = Position(row: position.row - 1, column: position.column + 1)
            if getPiece(from: rightCaptureMove)?.color == .black {
                validMoves.append(rightCaptureMove)
            }
        }
        return validMoves
    }

    private func resetStates() {
        for (rowIndex, row) in board.enumerated() {
            for (spotIndex, _) in row.enumerated() {
                board[rowIndex][spotIndex].spotState = .default
            }
        }
    }
}
