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

