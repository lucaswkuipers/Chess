protocol GameBrainDelegate {
    func setBoard(to board: [[Spot]])
}

final class GameBrain: GameBrainProtocol {
    var delegate: GameBrainDelegate?
    private var startingBoard = PieceParser.getBoard(from: BoardInitialLayoutVariant.standard.pieces)
    private var board =  PieceParser.getBoard(from: BoardInitialLayoutVariant.standard.pieces)
    private var playerTurn: Player = .bottom
    private var startingPlayer: Player = .bottom
    private var origin: Position?
    private var destination: Position?

    func getStartingBoard() -> [[Spot]] {
        return startingBoard
    }

    func didSelect(position: Position) {
        print("GameBrain: Did tap board spot of row: \(position.row), column: \(position.column)")

        if position == origin {
            cleanSelection()
            return
        }

        if isSelectionValid(of: position) {
            performSelection(on: position)
            return
        }

        if isSelectionSecond() {
            performMove()
            cleanSelection()
        }
    }

    private func updateBoard() {
        delegate?.setBoard(to: board)
    }

    private func performSelection(on position: Position) {
        if isSelectionFirst() {
            origin = position
            board[position.row][position.column].spotState = .origin
        } else {
            destination = position
            board[position.row][position.column].spotState = .destination
        }

        delegate?.setBoard(to: board)
    }

    private func performMove() {}

    private func isSelectionValid(of position: Position) -> Bool {
        isSelectionFirst() ? isOriginValid(on: position) : isDestinationValid(on: position)
    }

    private func isSelectionFirst() -> Bool {
        return origin == nil
    }

    private func isSelectionSecond() -> Bool {
        return origin != nil
    }

    private func isOriginValid(on position: Position) -> Bool {
        return isSameColorPieceOnPosition(on: position)
    }

    private func isDestinationValid(on position: Position) -> Bool {
        return isPositionInsideBoard(position) && !isSameColorPieceOnPosition(on: position) && isMoveValid(to: position)
    }

    private func isPositionInsideBoard(_ position: Position) -> Bool {
        return board[safeIndex: position.row]?[safeIndex: position.column] != nil
    }

    private func currentPlayerColor() -> PieceColor {
        return playerTurn == startingPlayer ? .white : .black
    }

    private func isSameColorPieceOnPosition(on position: Position) -> Bool {
        let selectedSpot = board[safeIndex: position.row]?[safeIndex: position.column]
        return selectedSpot?.piece?.color == currentPlayerColor()
    }

    private func isMoveValid(to destination: Position) -> Bool {
        guard let movingPieceType = board[safeIndex: destination.row]?[safeIndex: destination.column]?.piece?.type,
              let origin = origin else { return false }

        switch movingPieceType {
        case .pawn:
            return isPawnMoveValid(from: origin, to: destination)
        case .king:
            return isKingMoveValid(from: origin, to: destination)
        case .queen:
            return isQueenMoveValid(from: origin, to: destination)
        case .rook:
            return isRookMoveValid(from: origin, to: destination)
        case .bishop:
            return isBishopMoveValid(from: origin, to: destination)
        case .knight:
            return isKnightMoveValid(from: origin, to: destination)
        }
    }

    private func cleanSelection() {
        if let origin = origin {
            board[origin.row][origin.column].spotState = .default
        }

        if let destination = destination {
            board[destination.row][destination.column].spotState = .default
        }

        origin = nil
        destination = nil
        updateBoard()
    }

    private func isCurrentPlayerWhite() -> Bool {
        return currentPlayerColor() == .white
    }

    private func isCaptureMove(on position: Position) -> Bool {
        let pieceOnDestination = board[safeIndex: position.row]?[safeIndex: position.column]?.piece
        return pieceOnDestination?.color == currentPlayerColor()
    }

    private func isPawnMoveValid(from origin: Position, to destination: Position) -> Bool {
        if isCaptureMove(on: destination) {
            return isMoveToSide(origin: origin, destination: destination) && isMoveToFront(origin: origin, destination: destination)
        }
        return isMoveToFront(origin: origin, destination: destination)
    }

    private func isRookMoveValid(from origin: Position, to destination: Position) -> Bool {
        return isMoveOnSameRow(origin: origin, destination: origin) || isMoveOnSameColumn(origin: origin, destination: destination)
    }

    private func isBishopMoveValid(from origin: Position, to destination: Position) -> Bool {
        return isMoveOnDiagonal(origin: origin, destination: destination)
    }

    private func isQueenMoveValid(from origin: Position, to destination: Position) -> Bool {
        return isMoveOnDiagonal(origin: origin, destination: destination) || isMoveOnSameRow(origin: origin, destination: destination) || isMoveOnSameColumn(origin: origin, destination: destination)
    }

    private func isKingMoveValid(from origin: Position, to destination: Position) -> Bool {
        return false
    }

    private func isKnightMoveValid(from origin: Position, to destination: Position) -> Bool {
        return false
    }

    private func isMoveOnSameRow(origin: Position, destination: Position) -> Bool {
        return destination.row == origin.row
    }

    private func isMoveOnSameColumn(origin: Position, destination: Position) -> Bool {
        return destination.column == origin.column
    }

    private func isMoveOnDiagonal(origin: Position, destination: Position) -> Bool {
        return isMoveOnTopLeftToBottomRightDiagonal(origin: origin, destination: destination) || isMoveOnBottomLeftToTopRightDiagonal(origin: origin, destination: destination)
    }

    private func isMoveOnTopLeftToBottomRightDiagonal(origin: Position, destination: Position) -> Bool {
        return destination.row - destination.column == origin.row - origin.column
    }

    private func isMoveOnBottomLeftToTopRightDiagonal(origin: Position, destination: Position) -> Bool {
        return destination.row + destination.column == origin.row + origin.column
    }
}
