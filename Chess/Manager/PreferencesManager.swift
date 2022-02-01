import Foundation

final class PreferencesManager {
    static let shared = PreferencesManager()

    private init() {}

    let isRotationAnimatedDefault = true

    func save(isRotationAnimated: Bool) {
        UserDefaults.standard.set(isRotationAnimated, forKey: "isRotationAnimated")
    }

    func isRotationAnimated() -> Bool {
        return UserDefaults.standard.value(forKey: "isRotationAnimated") as? Bool ?? isRotationAnimatedDefault
    }

    func reseIsRotationAnimated() {
        UserDefaults.standard.set(isRotationAnimatedDefault, forKey: "isRotationAnimated")
    }

    let rotationAnimationDurationDefault = 0.5

    func save(rotationAnimationDuration: Double) {
        UserDefaults.standard.set(rotationAnimationDuration, forKey: "rotationAnimationDuration")
    }

    func rotationAnimationDuration() -> Double {
        return UserDefaults.standard.value(forKey: "rotationAnimationDuration") as? Double ?? rotationAnimationDurationDefault
    }

    func resetRotationAnimationDuration() {
        UserDefaults.standard.set(rotationAnimationDurationDefault, forKey: "rotationAnimationDuration")
    }

}
