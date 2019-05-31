//
//  UIAlertController+ErrorAlert.swift
//  IPad_App
//
//  Created by Mohammed Wasimuddin on 19.05.19.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func showErrorAlert(message: String, presentedBy viewController: UIViewController, actionHandler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = ViewCreationHelper.createAlertView(title: "Kitten iPadApp", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: actionHandler))
            viewController.present(alertController, animated: true)
        }
    }
}
