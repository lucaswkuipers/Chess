import UIKit

final class SpotButton: UIButton {
    let position: Position

    var defaultColor: UIColor? {
        didSet {
            backgroundColor = defaultColor
        }
    }

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

    init(on position: Position) {
        self.position = position
        super.init(frame: .zero)
        setBackgroundColor(for: position)
    }

    required init?(coder: NSCoder) {
        fatalError("Init of element not available through coder (you can't use .Xibs / .Storyboards, only init it programmatically)")
    }

    private func setBackgroundColor(for position: Position) {
        defaultColor = (position.row + position.column) % 2 == 0 ? .black : .white
    }
}
