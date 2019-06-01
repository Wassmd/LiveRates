import Foundation

final class RateConverterViewModel {
    

    // MARK: - Inner Types
    
    enum Constants {
        static let refreshInterval: TimeInterval = 5.0
    }
    
    
    // MARK: - Properties
    // MARK: Immutables
    
    private let networkService: NetworkService
    private let currencyPairService: CurrencyPairService
    
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
         currencyPairService: CurrencyPairService = CurrencyPairService.instance) {
        self.networkService = networkService
        self.currencyPairService = currencyPairService
        
         startRefreshTimer()
    }
    
    deinit {
        requestTimer?.invalidate()
    }


    // MARK: - Actions
    
    func fetchSavedCurrenciesPair() {
        currencyPairService.fetchSavedCurrenciesPair() { [weak self] saveCurrencyPairs, error in
            guard error == nil else { return }
            
            print("Wasim ***** \(String(describing: saveCurrencyPairs))")
            
            if let saveCurrencyPairs = saveCurrencyPairs {
                self?.savedCurrencyPairs = saveCurrencyPairs
            }
        }
    }
    
    func fetchConversionRates() {
        
        networkService.fetchRatesRequest(with: pairs)  { [weak self] (dictionary, error) in
             guard error == nil else { return }
            
            if let dictionary = dictionary {
                print("Wasim Thread: \(Thread.isMainThread)")
                self?.updatePairsWithRate(from: dictionary)
                self?.refeshTableView?()
            }
        }
    }
    
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
        
        requestTimer = Timer.scheduledTimer(withTimeInterval: Constants.refreshInterval, repeats: true, block: { [weak self] _ in
            self?.fetchConversionRates()
        })
    }
}
