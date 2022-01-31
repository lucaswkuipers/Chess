import UIKit

extension UIColor {
    func appliedOverlay(_ alpha: CGFloat, for color: UIColor?) -> UIColor? {
        guard let color = color else { return nil }
        let whiteComponents: [CGFloat] = [1.0, 1.0, 1.0, 1.0] //UIColor.white.cgColor.components only returns [1.0, 1.0]

        var rgba1: [CGFloat] = whiteComponents //set a valid default
        var rgba2: [CGFloat] = whiteComponents

        if let components = color.cgColor.components, components.count > 2 {
            rgba1 = components
        }

        if let components = self.cgColor.components, components.count > 2  {
            rgba2 = components
        }

        let r1: CGFloat = rgba1[0]
        let g1: CGFloat = rgba1[1]
        let b1: CGFloat = rgba1[2]

        let r2: CGFloat = rgba2[0]
        let g2: CGFloat = rgba2[1]
        let b2: CGFloat = rgba2[2]

        let r3 = ((1 - alpha) * r2) + (r1 * alpha)
        let g3 = ((1 - alpha) * g2) + (g1 * alpha)
        let b3 = ((1 - alpha) * b2) + (b1 * alpha)

        let newComponents: [CGFloat] = [r3, g3, b3, 1.0]
        let space = CGColorSpace(name:CGColorSpace.sRGB)!
        guard let cgColor3 = CGColor(colorSpace: space, components: newComponents) else {
            print("Failed to create new CGColor in default color space")
            return color
        }

        return UIColor(cgColor: cgColor3)
    }
}
