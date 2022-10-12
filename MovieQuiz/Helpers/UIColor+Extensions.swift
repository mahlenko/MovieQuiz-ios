import UIKit

extension UIColor {
    static var background: UIColor { UIColor(named: "background") ?? .black }
    static var backgroundImage: UIColor { UIColor(named: "backgroundImage") ?? .black }
    static var accent: UIColor { UIColor(named: "accent") ?? .white }
    static var fail: UIColor { UIColor(named: "danger") ?? .red }
    static var success: UIColor { UIColor(named: "success") ?? .green }
    static var secondary: UIColor { UIColor(named: "secondary") ?? .gray }
    static var overlay: UIColor { UIColor(named: "overlay") ?? .darkGray }
}
