import UIKit

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
