import UIKit

final class HapticsManager {
    static let shared = HapticsManager()

    private init() {}

    public func selectionVibrate() {
        DispatchQueue.main.async {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.prepare()
            selectionFeedbackGenerator.selectionChanged()
        }
    }

    public func impactVibration(style: UIImpactFeedbackGenerator.FeedbackStyle, at intensity: CGFloat) {
        DispatchQueue.main.async {
            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
            impactFeedbackGenerator.prepare()
            impactFeedbackGenerator.impactOccurred(intensity: intensity)
        }
    }

    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(type)
        }
    }
}
