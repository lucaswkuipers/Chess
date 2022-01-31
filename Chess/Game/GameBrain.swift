import Foundation

protocol GameBrainDelegate {
    func setBoard(to board: [[Spot]])
    func rotateBoard()
}

final class GameBrain: GameBrainProtocol {
    var delegate: GameBrainDelegate?
    private var currentPlayer: Player = .bottom
    private var startingPlayer: Player = .bottom
    private var origin: Position?
    private var validMoves: [Position] = []
    private var startingBoard = PieceParser.getBoard(from: BoardInitialLayoutVariant.standard.pieces)
    private var board =  PieceParser.getBoard(from: BoardInitialLayoutVariant.standard.pieces)
    private var numberOfRows: Int {
        board.count
    }
    private var numberOfColumns: Int {
        board.first?.count ?? 0
    }

    private var currentPlayerColor: PieceColor {
        return currentPlayer == startingPlayer ? .white : .black
    }

    func getStartingBoard() -> [[Spot]] {
        return startingBoard
    }

    func getStartingPlayer() -> Player {
        return startingPlayer
    }

    func didSelect(position: Position) {
        if origin == nil {
            selectOrigin(on: position)
        } else {
            selectDestination(on: position)
            makeMoveIfValid(on: position)
        }
    }

    private func makeMoveIfValid(on position: Position) {
        if validMoves.contains(position) {
            applyChanges(with: position)
        }
    }

    private func selectDestination(on position: Position) {
        if position == origin { return }
        let destinationPiece = getPiece(from: position)
        let originPiece = getPiece(from: origin)

        if destinationPiece?.color == originPiece?.color {
            selectOrigin(on: position)
        }
    }

    private func selectOrigin(on position: Position) {
        if isSpotSelectedEmpty(on: position) { return }
        if getPiece(from: position)?.color == currentPlayerColor {
            origin = position
            resetStates()
            setValidMoves(with: position)
            setState(.origin, to: position)
            HapticsManager.shared.impactVibration(style: .soft, at: 1)
        }
    }

    private func isSpotSelectedEmpty(on position: Position) -> Bool {
        return getPiece(from: position) == nil
    }

    private func getValidMoves(for position: Position) -> [Position] {
        guard let piece = getPiece(from: position) else { return [] }
        var validMoves: [Position] = []

        switch piece.type {
        case .king:
            validMoves = getValidKingMoves(from: position)
        case .queen:
            validMoves = getValidQueenMoves(from: position)
        case .rook:
            validMoves = getValidRookMoves(from: position)
        case .bishop:
            validMoves = getValidBishopMoves(from: position)
        case .knight:
            validMoves = getValidKnightMoves(from: position)
        case .pawn:
            validMoves = getValidPawnMoves(from: position)
        }
        return validMoves
    }

    private func setValidMoves(with position: Position) {
        validMoves = []
        guard let originPiece = getPiece(from: origin) else { return }
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
            validMoves = getValidKnightMoves(from: position)
        case .pawn:
            validMoves = getValidPawnMoves(from: position)
        }

        setValidMovesState()
    }

    private func setValidMovesState() {
        for move in validMoves {
            if getPiece(from: move) == nil {
                setState(.valid, to: move)
            } else {
                setState(.capture, to: move)
            }
        }
    }

    private func applyChanges(with position: Position) {
        resetStates()
        setPiece(getPiece(from: origin), to: position)
        cleanPiece(from: origin)
        resetStates()
        origin = nil
        printBoard() // log purposes (visualize what should be happening)
        currentPlayer = currentPlayer == .bottom ? .top : .bottom
        delegate?.setBoard(to: board)
        HapticsManager.shared.impactVibration(style: .heavy, at: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.delegate?.rotateBoard()
         }
    }

    private func setPiece(_ piece: Piece?, to position: Position?) {
        guard let position = position else { return }

        if position.row >= board.count { return }
        guard let row = board[safeIndex: position.row] else { return }
        if position.column >= row.count { return }

        board[position.row][position.column].piece = piece
        delegate?.setBoard(to: board)
    }

    private func getBoardWithPiece(piece: Piece?, on position: Position?, board: [[Spot]]) -> [[Spot]] {
        guard let position = position else { return board }
        var modifiedBoard = board

        if position.row >= board.count { return modifiedBoard }
        guard let row = board[safeIndex: position.row] else { return modifiedBoard }
        if position.column >= row.count { return modifiedBoard }

        modifiedBoard[position.row][position.column].piece = piece
        return modifiedBoard
    }


    private func setState(_ state: SpotState, to position: Position?) {
        guard let position = position else { return }

        if position.row >= board.count { return }
        guard let row = board[safeIndex: position.row] else { return }
        if position.column >= row.count { return }

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
                let pieceName = spot.piece == nil ? "     " : spot.piece!.abbreviation
                line.append("[\(pieceName)]")
            }
            print(line)
        }
    }

    private func getAttackedPositions(for color: PieceColor) -> [Position] {
        var attackedPositions: [Position] = []
        for (rowNumber, row) in board.enumerated() {
            for (columnNumber, spot) in row.enumerated() {
                if color == .black {
                    if spot.piece?.color == .white {
                        let validMoves = getCaptureMoves(for: Position(row: rowNumber, column: columnNumber))
                        attackedPositions.append(contentsOf: validMoves)
                    }
                } else if color == .white {
                    if spot.piece?.color == .black {
                        let validMoves = getCaptureMoves(for: Position(row: rowNumber, column: columnNumber))
                        attackedPositions.append(contentsOf: validMoves)
                    }
                }
            }
        }
        return attackedPositions
    }

    private func isKingInCheck(for color: PieceColor) -> Bool {
        let attackedPositions = getAttackedPositions(for: color)
        guard let kingPosition = getKingPosition(for: color) else { return false }
        return attackedPositions.contains(kingPosition)
    }

    private func getKingPosition(for color: PieceColor) -> Position? {
        for (rowNumber, row) in board.enumerated() {
            for (columnNumber, spot) in row.enumerated() {
                if spot.piece?.type == .king && spot.piece?.color == color {
                    return Position(row: rowNumber, column: columnNumber)
                }
            }
        }
        return nil
    }

    // MARK: - Pieces

    private func getValidKingMoves(from position: Position) -> [Position] {
        guard let color = getPiece(from: position)?.color else { return [] }
        var validMoves: [Position] = []
        var attackedPositions: [Position] = []

        if currentPlayerColor == color {
            attackedPositions = getAttackedPositions(for: color)
        }

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
        validMoves = validMoves.filter { !attackedPositions.contains($0) }
        return validMoves
    }

    private func getValidQueenMoves(from position: Position) -> [Position] {
        let color = getPiece(from: position)?.color
        var validMoves: [Position] = []

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
        return validMoves
    }

    private func getValidRookMoves(from position: Position) -> [Position] {
        let color = getPiece(from: position)?.color
        var validMoves: [Position] = []

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
        return validMoves
    }

    private func getValidBishopMoves(from position: Position) -> [Position] {
            let color = getPiece(from: position)?.color
        var validMoves: [Position] = []

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
        return validMoves
    }

    private func getValidKnightMoves(from position: Position) -> [Position] {
        let color = getPiece(from: position)?.color
        var validMoves: [Position] = []


        // 2 up 1 left
        let twoUpOneLeftMove = Position(row: position.row - 2, column: position.column - 1)
        if isMoveInBounds(on: twoUpOneLeftMove) && getPiece(from: twoUpOneLeftMove)?.color != color {
            validMoves.append(twoUpOneLeftMove)
        }

        // 2 up 1 right
        let twoUpOneRightMove = Position(row: position.row - 2, column: position.column + 1)
        if isMoveInBounds(on: twoUpOneRightMove) && getPiece(from: twoUpOneRightMove)?.color != color {
            validMoves.append(twoUpOneRightMove)
        }

        // 2 down 1 left
        let twoDownOneLeftMove = Position(row: position.row + 2, column: position.column - 1)
        if isMoveInBounds(on: twoDownOneLeftMove) && getPiece(from: twoDownOneLeftMove)?.color != color {
            validMoves.append(twoDownOneLeftMove)
        }

        // 2 down 1 right
        let twoDownOneRightMove = Position(row: position.row + 2, column: position.column + 1)
        if isMoveInBounds(on: twoDownOneRightMove) && getPiece(from: twoDownOneRightMove)?.color != color {
            validMoves.append(twoDownOneRightMove)
        }

        // 2 left 1 up
        let twoLeftOneUp = Position(row: position.row - 1, column: position.column - 2)
        if isMoveInBounds(on: twoLeftOneUp) && getPiece(from: twoLeftOneUp)?.color != color {
            validMoves.append(twoLeftOneUp)
        }

        // 2 left 1 down
        let twoLeftOneDown = Position(row: position.row + 1, column: position.column - 2)
        if isMoveInBounds(on: twoLeftOneDown) && getPiece(from: twoLeftOneDown)?.color != color {
            validMoves.append(twoLeftOneDown)
        }

        // 2 right 1 up
        let twoRightOneUp = Position(row: position.row - 1, column: position.column + 2)
        if isMoveInBounds(on: twoRightOneUp) && getPiece(from: twoRightOneUp)?.color != color {
            validMoves.append(twoRightOneUp)
        }

        // 2 right 1 down
        let twoRightOneDown = Position(row: position.row + 1, column: position.column + 2)
        if isMoveInBounds(on: twoRightOneDown) && getPiece(from: twoRightOneDown)?.color != color {
            validMoves.append(twoRightOneDown)
        }

        return validMoves
    }

    private func isMoveInBounds(on position: Position) -> Bool {
        return position.row < numberOfRows && position.row >= 0 && position.column < numberOfColumns && position.column >= 0
    }

    private func willMoveEndangerKing(move: Move, of color: PieceColor) -> Bool {
        let modifiedBoard = getBoardWithAppliedMove(move: move, on: board)
        return isKingInDanger(of: color, on: modifiedBoard)
    }

    private func isKingInDanger(of color: PieceColor, on board: [[Spot]]) -> Bool {
        let attackedPositions = getAttackedPositions(for: color, on: board)
        guard let kingPosition = getKingPosition(for: color, on: board) else { return false }
        return attackedPositions.contains(kingPosition)
    }

    private func getKingPosition(for color: PieceColor, on board: [[Spot]]) -> Position? {
        for (rowNumber, row) in board.enumerated() {
            for (columnNumber, spot) in row.enumerated() {
                if spot.piece?.type == .king && spot.piece?.color == color {
                    return Position(row: rowNumber, column: columnNumber)
                }
            }
        }
        return nil
    }

    private func getAttackedPositions(for color: PieceColor, on board: [[Spot]]) -> [Position] {
        var attackedPositions: [Position] = []
        for (rowNumber, row) in board.enumerated() {
            for (columnNumber, spot) in row.enumerated() {
                if color == .black {
                    if spot.piece?.color == .white {
                        let validMoves = getCaptureMoves(for: Position(row: rowNumber, column: columnNumber))
                        attackedPositions.append(contentsOf: validMoves)
                    }
                } else if color == .white {
                    if spot.piece?.color == .black {
                        let validMoves = getCaptureMoves(for: Position(row: rowNumber, column: columnNumber))
                        attackedPositions.append(contentsOf: validMoves)
                    }
                }
            }
        }
        return attackedPositions

    }

    private func getBoardWithAppliedMove(move: Move, on board: [[Spot]]) -> [[Spot]] {
        let origin = move.origin
        let destination = move.destination

        let piece = getPiece(from: origin)

        var modifiedBoard = getBoardWithPiece(piece: piece, on: destination, board: board)
        modifiedBoard = getBoardWithPiece(piece: nil, on: origin, board: modifiedBoard)

        return modifiedBoard
    }

    private func getCaptureMoves(for position: Position) -> [Position] {
        guard let piece = getPiece(from: position) else { return [] }
        var captureMoves: [Position] = []

        switch piece.type {
        case .king:
            captureMoves = getValidKingMoves(from: position)
        case .queen:
            captureMoves = getValidQueenMoves(from: position)
        case .rook:
            captureMoves = getValidRookMoves(from: position)
        case .bishop:
            captureMoves = getValidBishopMoves(from: position)
        case .knight:
            captureMoves = getValidKnightMoves(from: position)
        case .pawn:
            captureMoves = getPawnCaptureMoves(from: position)
        }
        return captureMoves
    }

    private func getPawnCaptureMoves(from position: Position) -> [Position] {
        guard let color = getPiece(from: position)?.color else { return [] }
        var validMoves: [Position] = []

        if color == .white {
            let leftCaptureMove = Position(row: position.row - 1, column: position.column - 1)
            validMoves.append(leftCaptureMove)

            let rightCaptureMove = Position(row: position.row - 1, column: position.column + 1)
            validMoves.append(rightCaptureMove)
        } else if color == .black {
            let leftCaptureMove = Position(row: position.row + 1, column: position.column - 1)
            validMoves.append(leftCaptureMove)

            let rightCaptureMove = Position(row: position.row + 1, column: position.column + 1)
            validMoves.append(rightCaptureMove)
        }
        return validMoves
    }

    private func getValidPawnMoves(from position: Position) -> [Position] {
        guard let color = getPiece(from: position)?.color else { return [] }
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
        } else if color == .black {
            // Initial two moves
            if position.row == 1 {
                let move = Position(row: 3, column: position.column)
                if getPiece(from: move)?.color != color {
                    let previousPosition = Position(row: 2, column: position.column)
                    if getPiece(from: previousPosition) == nil {
                        validMoves.append(move) // two moves down
                    }
                }
            }

            // Normal front
            let move = Position(row: position.row + 1, column: position.column)
            if getPiece(from: move) == nil {
                validMoves.append(move)
            }

            // Capture (diagonals)
            let leftCaptureMove = Position(row: position.row + 1, column: position.column - 1)
            if getPiece(from: leftCaptureMove)?.color == .white {
                validMoves.append(leftCaptureMove)
            }

            let rightCaptureMove = Position(row: position.row + 1, column: position.column + 1)
            if getPiece(from: rightCaptureMove)?.color == .white {
                validMoves.append(rightCaptureMove)
            }
        }
        validMoves = validMoves.filter { !willMoveEndangerKing(move: Move(origin: position, destination: $0), of: color)}
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
