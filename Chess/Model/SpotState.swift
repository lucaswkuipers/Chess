import UIKit

enum SpotState {
    case origin
    case capture
    case valid
    case `default`

    var color: UIColor? {
        switch self {
        case .origin:
            return .systemBlue
        case .capture:
            return .systemRed
        case .valid:
            return .systemGreen
        case .default:
            return nil
        }
    }
}
