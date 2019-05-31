import UIKit

protocol ReusableView: AnyObject {
    static var reuseString: String { get }
}

extension ReusableView {
    static var reuseString: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
