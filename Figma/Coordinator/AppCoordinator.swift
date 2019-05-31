//
//  AppCoordinator.swift
//  IPad_App
//
//  Created by Mohammed Wasimuddin on 18.05.19.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit

enum AppStep: CoordinatorStep {
    case showPhotoGridView
}

final class AppCoordinator: Coordinatable {
    
    // MARK: - Properties
    // MARK: Immutable
    
    public let identifier = UUID()
    weak var dismissable: CoordinatorDismissable?
    private let application : UIApplication
    
    
    // MARK: Mutable
    
    var childCoordinators = [UUID : Coordinatable]()
    private var window: UIWindow?
    
    
    // MARK: - Initializers
    
    init(dismissable: CoordinatorDismissable? = nil,
         application: UIApplication = UIApplication.shared) {
        self.dismissable = dismissable
        self.application = application
        
        setupWindow()
    }
    
    
    // MARK: - Setups
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        (application.delegate as? AppDelegate)?.window = window
    }
    
    
    // MARK: - Protocol Conformance
    // MARK: Coordinatable
    
    func coordinate(to step: CoordinatorStep) {
        guard let step = step as? AppStep else { return }
        switch step {
        case .showPhotoGridView:
            showPhotoGridView()
        }
    }
    
    func start() {
        coordinate(to: AppStep.showPhotoGridView)
    }
    
    
     // MARK: - Transitions
    
    private func showPhotoGridView() {
        let identifier = UUID()
        let photoGridCoordinator = PhotoGridCoordinator(
            identifier: identifier,
            dismissable: self,
            window: window)
        
        photoGridCoordinator.start()
        childCoordinators[identifier] = photoGridCoordinator
    }
}
