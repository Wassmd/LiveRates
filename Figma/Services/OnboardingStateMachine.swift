import Foundation

struct OnboardingStateMachine {
    
    
    // MARK: - Inner Types
    
    enum key {
        static let isAddCurrenyShown = "OnBoardingStateMachine.isAddCurrenyShown"
    }
    
    // MARK: - Properties
    // MARK: Immutable
    
    static let shared = OnboardingStateMachine()
    
    var isAddCurrenyShown: Bool {
        return userDefaults.bool(forKey: key.isAddCurrenyShown)
    }
    
    // MARK: Mutable
    
    var userDefaults = UserDefaults.standard
    
    
    // MARK: - Action
    
    func persistOnboardingShown() {
        userDefaults.set(true, forKey: OnboardingStateMachine.key.isAddCurrenyShown)
        userDefaults.synchronize()
    }
}
