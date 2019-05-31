import UIKit

extension UITableView {
    func registerReusableCell<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseString)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: T.reuseString, for: indexPath) as? T
        return cell.require()
    }
}
