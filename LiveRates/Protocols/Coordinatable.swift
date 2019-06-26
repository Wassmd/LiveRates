import Foundation

public protocol CoordinatorStep {}

public protocol CoordinatorDismissable: AnyObject {
    var childCoordinators: [UUID: Coordinatable] { get  set}
    
    func dispose(with identifier: UUID)
}

public protocol CoordinatorPresentable: AnyObject {
    var identifier: UUID { get }
    var dismissable: CoordinatorDismissable? { get }
    
    func coordinate(to step: CoordinatorStep)
    func start()
    func finish()
}


public protocol Coordinatable: CoordinatorPresentable, CoordinatorDismissable {}

public extension CoordinatorPresentable {
    func finish() {
        dismissable?.dispose(with: identifier)
    }
}

public extension CoordinatorDismissable {
    func dispose(with identifier: UUID) {
        childCoordinators[identifier] = nil
    }
}

