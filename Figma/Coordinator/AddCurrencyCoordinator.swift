//
//  PhotoGridCoordinator.swift
//  IPad_App
//
//  Created by Mohammed Wasimuddin on 18.05.19.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit

private enum PhotoGridSteps: CoordinatorStep {
    case showDetail(Photo)
    case showAlert(String)
}

class AddCurrencyCoordinator: Coordinatable {
    

    // MARK: - Properties
    // MARK: Immutable
    
    public let identifier: UUID
    private var window: UIWindow?
    private let navigationController: UINavigationController
    
    
    // MARK: - Mutable
    
    var dismissable: CoordinatorDismissable?
    var childCoordinators = [UUID : Coordinatable]()
    
    private lazy var photoGridViewModel = PhotoGridViewModel()
    private lazy var photoGridViewController: PhotoGridViewController = {
        photoGridViewModel.downloadKittensPhoto()
        let controller = PhotoGridViewController(
            viewModel: photoGridViewModel,
            coordinatorDelegate: self)
        
        return controller
    }()
    
    // MARK: - Initializers

    init(identifier: UUID,
         dismissable: CoordinatorDismissable? = nil,
         window: UIWindow?,
         navigationController: UINavigationController = UINavigationController()) {
        self.identifier = identifier
        self.dismissable = dismissable
        self.navigationController = navigationController
        self.window = window
    }
    
    
    // MARK: Protocol Conformance
    // MARK: Coordinatable
    
    func coordinate(to step: CoordinatorStep) {
        guard let step = step as? PhotoGridSteps else {
            return
        }
        switch step {
        case .showDetail(let photo):
            showPhotoDetail(with: photo)
        case .showAlert(let message):
            showRequestResponseErrorAlert(with: message)
        }
    }
    
    func start() {
        guard let window = window else { fatalError("window is not set") }
        
        navigationController.setViewControllers([photoGridViewController], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
    }
    
    // MARK: - Transitions
    
    private func showPhotoDetail(with photo: Photo) {
        let controller = PhotoDetailViewController(photo: photo)
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func showRequestResponseErrorAlert(with message: String) {
        UIAlertController.showErrorAlert(message: "The connection to server failed \n \(message)", presentedBy: self.photoGridViewController)
    }
}

extension AddCurrencyCoordinator: PhotoGridViewControllerDelegate {
    func showErrorAlert(with message: String) {
        coordinate(to: PhotoGridSteps.showAlert(message))
    }
    
    func showDetail(with photo: Photo) {
        coordinate(to: PhotoGridSteps.showDetail(photo))
    }
}
