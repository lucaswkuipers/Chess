import UIKit

final class SquareSpotButton: UIButton {
    enum SpotState {
        case origin
        case destination
        case valid
        case `default`

        var color: UIColor? {
            switch self {
            case .origin:
                return .systemBlue
            case .destination:
                return .systemYellow
            case .valid:
                return .systemGreen
            case .default:
                return nil
            }
        }
    }

    let defaultColor: UIColor
    let row: Int
    let column: Int

    var spotState: SpotState = .default {
        didSet {
            backgroundColor = spotState.color ?? defaultColor
        }
    }

    var piece: Piece? {
        didSet {
            guard let piece = piece else { return }
            setImage(UIImage(named: piece.imageName), for: .normal)
        }
    }

    init(row: Int, column: Int) {
        self.row  = row
        self.column = column
        self.defaultColor = (column + row) % 2 == 0 ? .white : .black
        super.init(frame: .zero)
        backgroundColor = defaultColor
    }

    required init?(coder: NSCoder) {
        fatalError("Init of element not available through coder (you can't use .Xibs / .Storyboards, only init it programmatically)")
    }
}
