import UIKit

extension UIAlertController {
    
    static func showAlertMessage(message: String, presentedBy viewController: UIViewController, actionHandler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = ViewCreationHelper.createAlertView(title: "Liverates", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: actionHandler))
            viewController.present(alertController, animated: true)
        }
    }
}
