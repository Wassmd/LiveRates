import Foundation

final class RateConverterViewModel {
    
    
    // MARK: - Inner Types
    
    enum Constants {
        static let refreshInterval: TimeInterval = 1.0
        static let domainLabel = "liverates.synchronizedArray"
    }
    
    
    // MARK: - Properties
    // MARK: Immutables
    
    private let networkService: NetworkService
    private let currencyPairService: CurrencyPairService
    private let notificationCenter: NotificationCenter
    private let onboardingStateMachine: OnboardingStateMachine
    private let queue = DispatchQueue(label: Constants.domainLabel, attributes: .concurrent)
    
    // MARK: Mutable
    
    private var requestTimer: Timer?
    private var isNewCurrencyPairAdded: Bool = false
    
    var refeshTableView: (() -> Void)?
    var addNewCurrencyOnTop: (() -> Void)?
    var handleError: ((Error) -> Void)?
    
    private var savedCurrencyPairs = [CurrencyPair]()
    private var currenciesWithRate = [CurrencyPair]()


    // MARK: - Public
    
    var sortedCurrenciesWithRate: [CurrencyPair] {
        return queue.sync {
             self.currenciesWithRate
        }
    }
    
    private var pairs: [String] {
        let pairs = savedCurrencyPairs.map { "\($0.fromCurrencyCode)\($0.targetCurrencyCode)" }
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
        
        setupObserving()
        
    }
    
    deinit {
        stopRateTimer()
    }
    
    func start() {
        setUpInitialData()
        startRefreshTimer()
    }
    
    // MARK: - setups
    
    private func setupObserving() {
        notificationCenter.addObserver(self, selector: #selector(savedCurrenciesChanges), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    private func setUpInitialData() {
        currencyPairService.fetchCurrencyPairsFromLocalDatabase() { [weak self] savedCurrencyPairs, error in
            guard let self = self else { return }
            guard error == nil else { return }
            
            guard let savedCurrencyPairs = savedCurrencyPairs, !savedCurrencyPairs.isEmpty else {
                return
            }
            
            self.updateSaveCurrencyPairs(with: savedCurrencyPairs)
            self.persistOnboardingShown(true)
            self.fireupRateRequestIfNeeded()
        }
    }
    
    
    // MARK: - Action
    
    func syncCurrencyPairsWithLocalDatabase() {
        currencyPairService.fetchCurrencyPairsFromLocalDatabase() { [weak self] savedCurrencyPairs, error in
            guard let self = self else { return }
            guard error == nil else { return }
            
            guard let savedCurrencyPairs = savedCurrencyPairs, !savedCurrencyPairs.isEmpty else {
                self.persistOnboardingShown(false)
                self.updateSaveCurrencyPairs(with: [])
                return
            }
            
            self.updateSaveCurrencyPairs(with: savedCurrencyPairs)
            self.persistOnboardingShown(true)
            self.fireupRateRequestIfNeeded()
        }
    }
    
    func fetchConversionRates() {
        guard !pairs.isEmpty else { print("Pairs are emplty!"); return }
        
        networkService.fetchConvertionRates(with: pairs)  { [weak self] (dictionary, error) in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    self?.handleError?(error)
                }
                self.updateSortedCurrenciesWithRate(with: self.savedCurrencyPairs)
            }
            
            guard let dictionary = dictionary, !dictionary.isEmpty else { return }
            
            self.updateConversationRates(from: dictionary)
        }
    }
    
    func handleAddNewCurrency(currencyPair: CurrencyPair)  {
        updateIsNewCurrencyPairAdded(true)
        persistNewCurrencyPair(currencyPair)
    }
    
    // MARK: - APIs
    
    private func persistNewCurrencyPair(_ currencyPair: CurrencyPair) {
        do {
            try currencyPairService.addCurrencyPair(currencyPair: currencyPair)
        } catch let error {
            print(error)
        }
    }
    
    func deleteCurrencyPair(at indexPath: IndexPath) throws {
        guard let currencyPair = currenciesWithRate[safe: indexPath.row] else { return }
        try currencyPairService.remove(currencyPair: currencyPair)
    }
    
    
    // MARK: - Helper
    
    private func fireupRateRequestIfNeeded() {
        fetchConversionRates()
    }
    
    func stopRateTimer() {
        requestTimer?.invalidate()
    }
    
    private func updateConversationRates(from dictionary: Dictionary<String, Any>) {
        let currencyPairs = dictionary.compactMap { (key, value) -> CurrencyPair? in
            let fromCurrencyCode = "\(key.fromCurrencyCode())"
            let targetCurrencyCode = "\(key.targetCurrencyCode())"
            let conversionRate = value as? Double
            
            guard var currencyPair = savedCurrencyPairs.first(where: { $0.fromCurrencyCode == fromCurrencyCode && $0.targetCurrencyCode == targetCurrencyCode }) else { return nil }
            
            currencyPair.updateConverstionRate(conversionRate)
            return currencyPair
            }
            .sorted(by: { $0.creationDate > $1.creationDate })
        
        updateSortedCurrenciesWithRate(with: currencyPairs)
        
    }
    
    func updateSortedCurrenciesWithRate(with currencyPairs: [CurrencyPair]) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            let shouldAddRowAtTop =  self.shouldAddRowAtTopWithAnimation(currencyPairs)
            self.currenciesWithRate = currencyPairs
            
            DispatchQueue.main.async {
                if shouldAddRowAtTop {
                    self.addNewCurrencyOnTop?()
                } else {
                    self.handleTableViewUpdate()
                }
            }
        }
    }

    func updateSaveCurrencyPairs(with currencyPairs: [CurrencyPair]) {
        savedCurrencyPairs = currencyPairs
    }
    
    private func handleTableViewUpdate() {
        self.refeshTableView?()
    }
    
    func updateIsNewCurrencyPairAdded(_ didFinishAdding: Bool) {
        isNewCurrencyPairAdded = didFinishAdding
    }
    
    private func shouldAddRowAtTopWithAnimation(_ currencyPairsWithRate: [CurrencyPair]) -> Bool {
        return currencyPairsWithRate.count > currenciesWithRate.count &&
            currenciesWithRate.count > 0 &&
        isNewCurrencyPairAdded
    }
    
    // MARK: - Timer
    
    func startRefreshTimer() {
        stopRateTimer()
        
        requestTimer = Timer.scheduledTimer(withTimeInterval: Constants.refreshInterval, repeats: true, block: { [weak self] _ in
            self?.fetchConversionRates()
        })
    }
    
    
    // MARK: - Notification
    
    @objc func savedCurrenciesChanges(notification: NSNotification) {
        syncCurrencyPairsWithLocalDatabase()
    }
    
    
    // MARK: - Persistence
    
    private func persistOnboardingShown(_ enable: Bool) {
        onboardingStateMachine.persistOnboardingShown(enable)
    }
}
