import UIKit

private enum RateConverterSteps: CoordinatorStep {
    case addCurrency
    case errorAlert(_ error: Error)
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
        guard let step = step as? RateConverterSteps else {
            return
        }
        switch step {
        case .addCurrency:
            showFromCurrency()
        case .errorAlert(let error):
            showErrorAlert(with: error)
        }
    }
    
    func start() {
        if rootViewController is AddCurrencyViewController {
            rootViewController = rateConverterViewController
            window?.rootViewController = rootViewController
            window?.makeKeyAndVisible()
            prepareModelForNewCurrency(with: newCurrencyPair)
        } else if rootViewController is RateConverterViewController {
            prepareModelForNewCurrency(with: newCurrencyPair)
        }  else {
            rootViewController = rateConverterViewController
            window?.rootViewController = rootViewController
            window?.makeKeyAndVisible()
        }
    }
    
    private func prepareModelForNewCurrency(with newCurrenyPair: CurrencyPair?) {
        if let newCurrencyPair = newCurrencyPair {
            if let rootViewController = rootViewController as? RateConverterViewController {
                rootViewController.viewModel.handleAddNewCurrency(currencyPair: newCurrencyPair)
           }
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
    
    
    // MARK: Alerts
    
    private func showErrorAlert(with error: Error) {
        var errorMessage = "Failed to get rates."
        if let requestError = error as? RequestError {
            switch requestError {
            case .networkError:
                errorMessage = "The connection to server failed. Check your network connection"
            case .unknown:
                errorMessage = "server Error"
            case .invalidURL:
                print("Invalid URL")
            }
        }
        
        if let rootViewController = rootViewController {
            UIAlertController.showAlertMessage(message: errorMessage, presentedBy: rootViewController)
        }
    }
}

extension RateConverterCoordinator: RateConverterViewControllerDelegate {
    func addCurrency() {
        coordinate(to: RateConverterSteps.addCurrency)
    }
    
    func errorAlert(with error: Error) {
        coordinate(to: RateConverterSteps.errorAlert(error))
    }
}
