import UIKit

extension UIColor {
    static var background: UIColor { UIColor(named: "background") ?? .black }
    static var accent: UIColor { UIColor(named: "default") ?? .white }
    static var fail: UIColor { UIColor(named: "fail") ?? .red }
    static var success: UIColor { UIColor(named: "success") ?? .green }
    static var secondary: UIColor { UIColor(named: "secondary") ?? .darkGray }
}
