import UIKit

private enum AddCurrencySteps: CoordinatorStep {
    case addCurrency
    case showCurrency
}

final class AddCurrencyCoordinator: Coordinatable {
    

    // MARK: - Properties
    // MARK: Immutable
    
    public let identifier: UUID
    
    
    // MARK: - Mutable
    
    var dismissable: CoordinatorDismissable?
    var childCoordinators = [UUID : Coordinatable]()
    private var window: UIWindow?
    private lazy var rootViewController = AddCurrencyViewController(coordinatorDelegate: self)
    
    
    // MARK: - Initializers

    init(identifier: UUID,
         dismissable: CoordinatorDismissable? = nil,
         window: UIWindow?) {
        self.identifier = identifier
        self.dismissable = dismissable
        self.window = window

    }
    
    
    // MARK: Protocol Conformance
    // MARK: Coordinatable
    
    func coordinate(to step: CoordinatorStep) {
        guard let step = step as? AddCurrencySteps else {
            return
        }
        switch step {
        case .addCurrency:
            showAddCurrency()
        case .showCurrency:
            showCurrencyView()
        }
    }
    
    func start() {
        coordinate(to: AddCurrencySteps.addCurrency)
    }
    
    // MARK: - Transitions
    
    private func showAddCurrency() {
        guard let window = window else { fatalError("Window is not set") }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
    }
    
    private func showCurrencyView() {
        let identifier = UUID()
        let coordinator = CurrencyCoordinator(
            identifier: identifier,
            dismissable: dismissable,
            window: window,
            rootViewController: rootViewController)
        
        coordinator.start()
        childCoordinators[identifier] = coordinator
    }
}

extension AddCurrencyCoordinator: AddCurrencyViewControllerDelegate {
    func showCurrency() {
        coordinate(to: AddCurrencySteps.showCurrency)
    }
}

extension AddCurrencyCoordinator: RateConverterViewControllerDelegate {
    func errorAlert(with error: Error) {}
    
    func addCurrency() {
        coordinate(to: AddCurrencySteps.showCurrency)
    }
}

