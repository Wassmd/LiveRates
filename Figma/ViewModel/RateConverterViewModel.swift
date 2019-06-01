import Foundation

final class RateConverterViewModel {
    
    
    // MARK: - Inner Types
    
    enum Constants {
        static let refreshInterval: TimeInterval = 10.0
    }
    
    
    // MARK: - Properties
    // MARK: Immutables
    
    private let networkService: NetworkService
    let currencyPairService: CurrencyPairService
    private let notificationCenter: NotificationCenter
    private let onboardingStateMachine: OnboardingStateMachine
    
    // MARK: Mutable
    
    var refeshTableView: (() -> ())?
    private var requestTimer: Timer?
    
    private var savedCurrencyPairs = [CurrencyPair]()
    var sortedCurrenciesWithRate = [CurrencyPair]()
    
    private var pairs: [String] {
        return savedCurrencyPairs.map { "\($0.fromCurrencyCode)\($0.targetCurrencyCode)" }
    }
    
    
    // MARK: - Initializers
    
    init(networkService: NetworkService = NetworkService(),
         currencyPairService: CurrencyPairService = CurrencyPairService.instance,
         notificationCenter: NotificationCenter = NotificationCenter.default,
         onboardingStateMachine: OnboardingStateMachine = OnboardingStateMachine()) {
        self.networkService = networkService
        self.currencyPairService = currencyPairService
        self.notificationCenter = notificationCenter
        self.onboardingStateMachine = onboardingStateMachine
        
        setupObserving()
        startRefreshTimer()
    }
    
    deinit {
        requestTimer?.invalidate()
    }
    
    
    // MARK: setupObserving
    private func setupObserving() {
        notificationCenter.addObserver(self, selector: #selector(savedCurrenciesChanges), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    
    // MARK: - APIs
    
    func fetchSavedCurrenciesPair() {
        currencyPairService.fetchSavedCurrenciesPair() { [weak self] saveCurrencyPairs, error in
            guard let self = self else { return }
            guard error == nil else { return }
            guard let saveCurrencyPairs = saveCurrencyPairs else { return }
            
            self.savedCurrencyPairs = saveCurrencyPairs
            self.requestTimer?.fire()
            self.persistOnboardingShown()
        }
    }
    
    @objc func fetchConversionRates() {
        networkService.fetchRatesRequest(with: pairs)  { [weak self] (dictionary, error) in
            guard error == nil else { return }
            guard let dictionary = dictionary else { return }
            print("Wasim Thread: \(Thread.isMainThread)")
            self?.updatePairsWithRate(from: dictionary)
            self?.refeshTableView?()
            
        }
    }
    
    func deleteCurrencyPair(at indexPath: IndexPath) throws {
         guard let currencyPair = sortedCurrenciesWithRate[safe: indexPath.row] else { return }
        try currencyPairService.remove(currencyPair: currencyPair)
    }
    
    
    // MARK: - Helper
    
    private func updatePairsWithRate(from dictionary: Dictionary<String, Any>) {
        let pairs = dictionary.compactMap { (key, value) -> CurrencyPair? in
            let fromCurrencyCode = "\(key.fromCurrencyCode())"
            let targetCurrencyCode = "\(key.targetCurrencyCode())"
            let conversionRate = value as? Double
            guard var currencyPair = savedCurrencyPairs.first(where: { $0.fromCurrencyCode == fromCurrencyCode && $0.targetCurrencyCode == targetCurrencyCode }) else { return nil}
            currencyPair.conversionRate = conversionRate
            return currencyPair
            }
            .sorted(by: { $0.creationDate > $1.creationDate })
        
        sortedCurrenciesWithRate = pairs
    }
    
    // MARK: Timer
    
    private func startRefreshTimer() {
        requestTimer?.invalidate()
        requestTimer = Timer.scheduledTimer(timeInterval: Constants.refreshInterval, target: self, selector: #selector(fetchConversionRates), userInfo: nil, repeats: true)
    }
    
    // MARK: Notification
    
    @objc private func savedCurrenciesChanges() {
        print("Wasim saveCurrenciesChanges")
        fetchSavedCurrenciesPair()
    }
    
    
    // MARK: Persist
    
    private func persistOnboardingShown() {
        savedCurrencyPairs.count > 0 ? onboardingStateMachine.persistOnboardingShown(true) :  onboardingStateMachine.persistOnboardingShown(false)
    }

}
