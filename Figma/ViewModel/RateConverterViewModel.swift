import Foundation

final class RateConverterViewModel {
    
    
    // MARK: - Inner Types
    
    enum Constants {
        static let refreshInterval: TimeInterval = 3.0
    }
    
    
    // MARK: - Properties
    // MARK: Immutables
    
    private let networkService: NetworkService
    let currencyPairService: CurrencyPairService
    private let notificationCenter: NotificationCenter
    private let onboardingStateMachine: OnboardingStateMachine
    
    // MARK: Mutable
    
    private var requestTimer: Timer?
    var shouldAddNewCurrencyPair: Bool = false
    
    var refeshTableView: (() -> Void)?
    var addNewCurrencyOnTop: (() -> Void)?
    var handleError: ((Error) -> Void)?
    
    fileprivate(set) var sortedCurrenciesWithRate1 = Set<CurrencyPair>()
    var sortedCurrenciesWithRate = [CurrencyPair]()
    
    private var pairs: [String] {
        let pairs = sortedCurrenciesWithRate.map { "\($0.fromCurrencyCode)\($0.targetCurrencyCode)" }
        return pairs
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
        
        setUpInitialData()
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
    
    
    // MARK: - Action
    private func setUpInitialData() {
        currencyPairService.fetchCurrenciesPairFromLocalDatabase() { [weak self] savedCurrencyPairs, error in
            guard let self = self else { return }
            guard error == nil else { return }
            
            guard let savedCurrencyPairs = savedCurrencyPairs, !savedCurrencyPairs.isEmpty else {
                return
            }
            
            self.updateSortedCurrenciesWithRate(with: savedCurrencyPairs)
            self.persistOnboardingShown(true)
            self.fireupRateRequestIfNeeded()
        }
    }
    
    func setupSavedCurrenciesPairs() {
        currencyPairService.fetchCurrenciesPairFromLocalDatabase() { [weak self] savedCurrencyPairs, error in
            guard let self = self else { return }
            guard error == nil else { return }
            
            guard let savedCurrencyPairs = savedCurrencyPairs, !savedCurrencyPairs.isEmpty else {
                self.persistOnboardingShown(false)
                self.updateSortedCurrenciesWithRate(with: [])
                return
            }
            
            self.updateSortedCurrenciesWithRate(with: savedCurrencyPairs)
            self.persistOnboardingShown(true)
            self.fireupRateRequestIfNeeded()
        }
    }
    
    @objc func fetchConversionRates() {
        guard !pairs.isEmpty else { print("Pairs are emplty!"); return }
        
        networkService.fetchConvertionRates(with: pairs)  { [weak self] (dictionary, error) in
            guard let self = self else { return }
            if let error = error {
                self.handleError?(error)
            }
            
            guard let dictionary = dictionary, !dictionary.isEmpty else { return }
        
            self.updateConversationRates(from: dictionary)
            self.handleTableViewUpdate()
        }
    }
    
    func handleAddNewCurrency(currencyPair: CurrencyPair)  {
        sortedCurrenciesWithRate.insert(currencyPair, at: 0)
        print("Wasim sorted count \(sortedCurrenciesWithRate.count)")
        
        fireupRateRequestIfNeeded()
        persistNewCurrencyPair(currencyPair)
    }
    
    // MARK: - APIs
    
    func persistNewCurrencyPair(_ currencyPair: CurrencyPair) {
        do {
            try currencyPairService.addCurrencyPair(currencyPair: currencyPair)
        } catch let error {
            print(error)
        }
    }
    
    func deleteCurrencyPair(at indexPath: IndexPath) throws {
        guard let currencyPair = sortedCurrenciesWithRate[safe: indexPath.row] else { return }
        try currencyPairService.remove(currencyPair: currencyPair)
    }

    
    // MARK: - Helper
    
    private func fireupRateRequestIfNeeded() {
        requestTimer?.fire()
    }
    
    private func updateConversationRates(from dictionary: Dictionary<String, Any>) {
        print("Wasim sortedCurrenciesWithRate begin: \(sortedCurrenciesWithRate)")
        let currenciesPair = dictionary.compactMap { (key, value) -> CurrencyPair? in
            let fromCurrencyCode = "\(key.fromCurrencyCode())"
            let targetCurrencyCode = "\(key.targetCurrencyCode())"
            let conversionRate = value as? Double
            guard var currencyPair = sortedCurrenciesWithRate.first(where: { $0.fromCurrencyCode == fromCurrencyCode && $0.targetCurrencyCode == targetCurrencyCode }) else { return nil }
            currencyPair.conversionRate = conversionRate
            return currencyPair
            }
            .sorted(by: { $0.creationDate > $1.creationDate })
        
        updateSortedCurrenciesWithRate(with: currenciesPair)

    }
    
    private func updateSortedCurrenciesWithRate(with currenciesPair: [CurrencyPair]) {
        sortedCurrenciesWithRate = currenciesPair
    }
    
    private func handleTableViewUpdate() {
//         shouldAddNewCurrencyPair ? self.addNewCurrencyOnTop?() : self.refeshTableView?()
        shouldAddNewCurrencyPair ? self.refeshTableView?() : self.refeshTableView?()
    }
    
    
    // MARK: - Timer
    
    private func startRefreshTimer() {
        requestTimer?.invalidate()
        requestTimer = Timer.scheduledTimer(timeInterval: Constants.refreshInterval, target: self, selector: #selector(fetchConversionRates), userInfo: nil, repeats: true)
    }
    
    
    // MARK: - Notification
    
    @objc func savedCurrenciesChanges() {
        setupSavedCurrenciesPairs()
    }
    
    
    // MARK: - Persistence
    
    private func persistOnboardingShown(_ enable: Bool) {
        onboardingStateMachine.persistOnboardingShown(enable)
    }
}
