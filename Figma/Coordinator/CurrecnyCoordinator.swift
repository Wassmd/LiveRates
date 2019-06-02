import UIKit

private enum currencySteps: CoordinatorStep {
    case toCurrency(currency: Currency)
    case rateConverter(_ newCurrencyPair: CurrencyPair)
}

final class CurrencyCoordinator: Coordinatable {
    
    
    // MARK: - Properties
    // MARK: Immutable
    
    public let identifier: UUID
    private var window: UIWindow?
    private let navigationController: UINavigationController
    private let rootViewController: UIViewController
    
    
    // MARK: - Mutable
    
    var dismissable: CoordinatorDismissable?
    var childCoordinators = [UUID : Coordinatable]()
    
    private lazy var currencyViewModel = BaseCurrencyViewModel()
    private lazy var fromCurrencyViewController = FromCurrencyViewController(viewModel: currencyViewModel,
                                                                     coordinatorDelegate: self)
    
    // MARK: - Initializers
    
    init(identifier: UUID,
         dismissable: CoordinatorDismissable? = nil,
         window: UIWindow?,
         navigationController: UINavigationController = UINavigationController(),
         rootViewController: UIViewController) {
        self.identifier = identifier
        self.dismissable = dismissable
        self.navigationController = navigationController
        self.window = window
        self.rootViewController = rootViewController
    }
    
    // MARK: Protocol Conformance
    // MARK: Coordinatable
    
    func coordinate(to step: CoordinatorStep) {
        guard let step = step as? currencySteps else {
            return
        }
        switch step {
        case .toCurrency(let currency):
            showTargetCurrency(currency: currency)
        case .rateConverter(let currencyPair):
            showRateConverter(currencyPair)
        }
    }
    
    func start() {
        navigationController.setViewControllers([fromCurrencyViewController], animated: false)
        rootViewController.present(navigationController, animated: true, completion: nil)
    }
    
    private func showTargetCurrency(currency: Currency) {
        let viewModel = TargetCurrencyViewModel(selectedFromCurrency: currency)
        let controller = TargetCurrencyViewController(viewModel: viewModel, coordinatorDelegate: self)
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func showRateConverter(_ newCurrencyPair: CurrencyPair) {
        let identifier = UUID()
        let coordinator = RateConverterCoordinator(
            identifier: identifier,
            dismissable: self,
            rootViewController: rootViewController,
            window: window,
            newCurrencyPair: newCurrencyPair)
        
        coordinator.start()
        childCoordinators[identifier] = coordinator
    }

}

extension CurrencyCoordinator: FromCurrencyViewControllerDelegate {
    func selectedFromCurrency(_ currency: Currency) {
        coordinate(to: currencySteps.toCurrency(currency: currency))
    }
}

extension CurrencyCoordinator: TargetCurrencyViewControllerDelegate {
    func maxPairingAchieved() {
        navigationController.dismiss(animated: true) { [weak self] in
            self?.finish()
        }
    }
    
    func selectedTargetCurrency(_ newCurrencyPair: CurrencyPair) {
        coordinate(to: currencySteps.rateConverter(newCurrencyPair))
        navigationController.dismiss(animated: true) { [weak self] in
            self?.finish()
        }
    }
}


