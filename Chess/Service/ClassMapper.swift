//final class ClassMapper {
//    static func getPieceClass(from pieceType: PieceType) -> PieceProtocol {
//        switch pieceType {
//        case .king:
//            return King()
//        case .queen:
//            return Queen()
//        case .rook:
//            return Rook()
//        case .bishop:
//            return Rook()
//        case .knight:
//            return Knight()
//        case .pawn:
//            return Pawn()
//        }
//    }
//}
//
//final class MovesChecker {
//    static func isMoveToSide(from origin: Position, to destination: Position) -> Bool {
//        return destination.column == origin.column + 1 || destination.column == origin.column - 1
//    }
//
//    static func isMoveToFront(from origin: Position, to destination: Position, isBottomPlayer: Bool) -> Bool {
//        let directionSignal = isBottomPlayer ? -1 : 1
//        return destination.row == origin.row + directionSignal
//    }
//}
//
//protocol PieceProtocol {
//    func isMoveValid(from origin: Position, to destination: Position) -> Bool
//}
//
//struct King: PieceProtocol {
//    func isMoveValid(from origin: Position, to destination: Position) -> Bool {
//    }
//}
//struct Queen: PieceProtocol {
//    func isMoveValid(from origin: Position, to destination: Position) -> Bool {
//    }
//}
//struct Rook: PieceProtocol {
//    func isMoveValid(from origin: Position, to destination: Position) -> Bool {
//    }
//}
//struct Bishop: PieceProtocol {
//    func isMoveValid(from origin: Position, to destination: Position) -> Bool {
//    }
//}
//struct Knight: PieceProtocol {
//    func isMoveValid(from origin: Position, to destination: Position) -> Bool {
//    }
//}
//struct Pawn: PieceProtocol {
//    let board: [[Spot]] = []
//
//    func isMoveValid(from origin: Position, to destination: Position) -> Bool {
//        let isBottomPlayer = board[safeIndex: origin.row]?[safeIndex: origin.column]?.piece?.color == .white
//
//        if MovesChecker.isMoveToFront(from: origin, to: destination, isBottomPlayer: isBottomPlayer) {
//            let destinationSpot = board[safeIndex: destination.row]?[safeIndex: destination.column]
//            return destinationSpot?.piece == nil
//        }
//
//
//    }
//
//    private func isCaptureMove(from origin: Position, to destination: Position) -> Bool {
//    }
//}
