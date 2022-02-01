protocol Reusable {}

extension Reusable {
    static var reuseIdentifer: String {
        return String(describing: self)
    }
}
