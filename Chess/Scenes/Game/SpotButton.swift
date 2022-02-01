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
            backgroundColor = defaultColor?.appliedOverlay(0.8, for: spotState.color) ?? defaultColor
        }
    }

    var piece: Piece? {
        didSet {
            if let piece = piece {
                setImage(UIImage(named: piece.imageName), for: .normal)
            } else {
                setImage(nil, for: .normal)
            }
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

    func rotate() {
        UIView.animate(withDuration: 1, delay: 0, options: [.preferredFramesPerSecond60, .curveEaseInOut], animations: {
            self.imageView?.transform = self.imageView?.transform.rotated(by: .pi) ?? .identity
        }, completion: nil)
    }

    private func setBackgroundColor(for position: Position) {
        defaultColor = (position.row + position.column) % 2 == 0 ? .systemBrown : .white
    }
}
