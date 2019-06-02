import UIKit

private enum rateConverterSteps: CoordinatorStep {
    case addCurrency
}

final class RateConverterCoordinator: Coordinatable {
    
    // MARK: - Properties
    // MARK: Immutable
    
    public let identifier: UUID
    private let navigationController: UINavigationController
    private let newCurrencyPair: CurrencyPair?
    
    // MARK: - Mutable
    
    var dismissable: CoordinatorDismissable?
    var childCoordinators = [UUID : Coordinatable]()
    
    private weak var window: UIWindow?
    private weak var rootViewController: UIViewController?
    private lazy var viewModel = RateConverterViewModel()
    private lazy var rateConverterViewController = RateConverterViewController(
        viewModel: viewModel,
        coordinatorDelegate: self)
    
    
    // MARK: - Initializers
    
    init(identifier: UUID,
         dismissable: CoordinatorDismissable? = nil,
         rootViewController: UIViewController?,
         window: UIWindow?,
         navigationController: UINavigationController = UINavigationController(),
         newCurrencyPair: CurrencyPair? = nil) {
        self.identifier = identifier
        self.dismissable = dismissable
        self.navigationController = navigationController
        self.rootViewController = rootViewController
        self.window = window
        self.newCurrencyPair = newCurrencyPair
    }
    
    
    // MARK: Protocol Conformance
    // MARK: Coordinatable
    
    func coordinate(to step: CoordinatorStep) {
        guard let step = step as? rateConverterSteps else {
            return
        }
        switch step {
        case .addCurrency:
            showFromCurrency()
        }
    }
    
    func start() {
        if rootViewController is AddCurrencyViewController {
            rootViewController = rateConverterViewController
            if let newCurrencyPair = newCurrencyPair {
                rateConverterViewController.viewModel.handleAddNewCurrency(currencyPair: newCurrencyPair)
            }
            window?.rootViewController = rateConverterViewController
            window?.makeKeyAndVisible()
        } else if rootViewController is RateConverterViewController {
            if let newCurrencyPair = newCurrencyPair {
                (rootViewController as! RateConverterViewController).viewModel.handleAddNewCurrency(currencyPair: newCurrencyPair)
            }
        }  else {
            window?.rootViewController = rateConverterViewController
            window?.makeKeyAndVisible()
        }
    }
    
    private func showFromCurrency() {
        let identifier = UUID()
        let coordinator = CurrencyCoordinator(
            identifier: identifier,
            dismissable: self,
            window: window,
            rootViewController: rateConverterViewController)
        
        coordinator.start()
        childCoordinators[identifier] = coordinator
    }
}

extension RateConverterCoordinator: RateConverterViewControllerDelegate {
    func addCurrency() {
        coordinate(to: rateConverterSteps.addCurrency)
    }
}
