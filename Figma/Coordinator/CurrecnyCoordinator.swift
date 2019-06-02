import UIKit

private enum CurrencySteps: CoordinatorStep {
    case toCurrency(currency: Currency)
    case rateConverter(_ newCurrencyPair: CurrencyPair)
    case informativeAlert(message: String)
    
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
        guard let step = step as? CurrencySteps else {
            return
        }
        switch step {
        case .toCurrency(let currency):
            showTargetCurrency(currency: currency)
        case .rateConverter(let currencyPair):
            showRateConverter(currencyPair)
        case .informativeAlert(let message):
            showInformativeAlert(with: message)
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
    
    
    // MARK: Alert
    
    private func showInformativeAlert(with message: String) {
        UIAlertController.showAlertMessage(message: message, presentedBy: rootViewController)
    }
}

extension CurrencyCoordinator: FromCurrencyViewControllerDelegate {
    func selectedFromCurrency(_ currency: Currency) {
        coordinate(to: CurrencySteps.toCurrency(currency: currency))
    }
}

extension CurrencyCoordinator: TargetCurrencyViewControllerDelegate {
    func maxPairingAchieved() {
        navigationController.dismiss(animated: true) { [weak self] in
            self?.finish()
        }
    }
    
    func selectedTargetCurrency(_ newCurrencyPair: CurrencyPair) {
        coordinate(to: CurrencySteps.rateConverter(newCurrencyPair))
        navigationController.dismiss(animated: true) { [weak self] in
            self?.finish()
        }
    }
    
    func infoAlert(with message: String) {
        coordinate(to: CurrencySteps.informativeAlert(message: message))
    }
}


