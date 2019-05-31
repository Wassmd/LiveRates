import UIKit

enum AppStep: CoordinatorStep {
    case addCurrency
    case rateConverter
}

final class AppCoordinator: Coordinatable {
    
    // MARK: - Properties
    // MARK: Immutable
    
    public let identifier = UUID()
    weak var dismissable: CoordinatorDismissable?
    private let application : UIApplication
    private let onboardingStateMachine: OnboardingStateMachine
    
    // MARK: Mutable
    
    var childCoordinators = [UUID : Coordinatable]()
    private var window: UIWindow?
    
    
    // MARK: - Initializers
    
    init(dismissable: CoordinatorDismissable? = nil,
         application: UIApplication = UIApplication.shared,
         onboardingStateMachine: OnboardingStateMachine = OnboardingStateMachine.shared) {
        self.dismissable = dismissable
        self.application = application
        self.onboardingStateMachine = onboardingStateMachine
        
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
        case .addCurrency:
            showAddCurrency()
        case .rateConverter:
            showRateConveter()
        }
    }
    
    func start() {
        print("Wasim isAddCurrenyShown:\(onboardingStateMachine.isAddCurrenyShown)")
       if onboardingStateMachine.isAddCurrenyShown {
            coordinate(to: AppStep.rateConverter)
       } else {
            coordinate(to: AppStep.addCurrency)
        }
    }
    
    
     // MARK: - Transitions
    
    private func showAddCurrency() {
        let identifier = UUID()
        let addCurrencyCoordinator = AddCurrencyCoordinator(
            identifier: identifier,
            dismissable: self,
            window: window)
        
        addCurrencyCoordinator.start()
        childCoordinators[identifier] = addCurrencyCoordinator
    }
    
    private func showRateConveter() {
        let identifier = UUID()
        let coordinator = RateConverterCoordinator(
            identifier: identifier,
            dismissable: self,
            window: window)
        
        coordinator.start()
        childCoordinators[identifier] = coordinator
    }
}
