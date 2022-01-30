struct Piece {
    let type: PieceType
    let color: PieceColor

    var imageName: String {
        color.name + "_" + type.name
    }

    var abbreviation: String {
        color.name.first!.uppercased() + "_" + type.name[0...2].uppercased()
    }
}

extension String {

    subscript(bounds: CountableClosedRange<Int>) -> String {
        let lowerBound = max(0, bounds.lowerBound)
        guard lowerBound < self.count else { return "" }

        let upperBound = min(bounds.upperBound, self.count-1)
        guard upperBound >= 0 else { return "" }

        let i = index(startIndex, offsetBy: lowerBound)
        let j = index(i, offsetBy: upperBound-lowerBound)

        return String(self[i...j])
    }

    subscript(bounds: CountableRange<Int>) -> String {
        let lowerBound = max(0, bounds.lowerBound)
        guard lowerBound < self.count else { return "" }

        let upperBound = min(bounds.upperBound, self.count)
        guard upperBound >= 0 else { return "" }

        let i = index(startIndex, offsetBy: lowerBound)
        let j = index(i, offsetBy: upperBound-lowerBound)

        return String(self[i..<j])
    }
}
