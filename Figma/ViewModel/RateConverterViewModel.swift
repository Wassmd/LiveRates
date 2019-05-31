import Foundation

final class RateConverterViewModel {
    
    
    //MARK: - Properties
    //MARK: Immutables
    
    private let networkService: NetworkService
    private let currencyPairService: CurrencyPairService
    private var savedCurrencyPairs = [CurrencyPair]()
    var currenciesWithRate = [CurrencyPair]()
    
    private var pairs: [String] {
        return savedCurrencyPairs.map { "\($0.fromCurrencyCode)\($0.targetCurrencyCode)" }
    }
    
    
     //MARK: - Initializers

    init(networkService: NetworkService = NetworkService(),
         currencyPairService: CurrencyPairService = CurrencyPairService.instance) {
        self.networkService = networkService
        self.currencyPairService = currencyPairService
        
    }
    
    
    //MARK: - Action

    func fetchSavedCurrenciesPair(completion: @escaping (() -> Void)) {
        currencyPairService.fetchSavedCurrenciesPair() { [weak self] saveCurrencyPairs, error in
            guard error == nil else { return }
            
            print("Wasim ***** \(String(describing: saveCurrencyPairs))")
            
            if let saveCurrencyPairs = saveCurrencyPairs {
                self?.savedCurrencyPairs = saveCurrencyPairs
                completion()
            }
        }
    }
    
    func fetchRateConversion(completion: @escaping (() -> Void)) {
        
        networkService.fetchPhotosRequest(with: pairs)  { [weak self] (dictionary, error) in
             guard error == nil else { return }
            
            if let dictionary = dictionary {
                print("Wasim \(dictionary)")
                for dict in dictionary {
                    print("Wasim key: \(dict.key) vale:\(dict.value)")
                    self?.createCurrenciesPairWithRates(key: dict.key, value: dict.value as? Double)
                }
                completion()
            }
        }
    }
    
    private func createCurrenciesPairWithRates(key: String, value: Double?) {
        let fromCurrencyCode = "\(key.fromCurrencyCode())"
        let targetCurrencyCode = "\(key.targetCurrencyCode())"
        let conversionRate = value
        
        guard var currencyPair = savedCurrencyPairs.first(where: { $0.fromCurrencyCode == fromCurrencyCode && $0.targetCurrencyCode == targetCurrencyCode }) else { return }
        
        currencyPair.conversionRate = conversionRate
        currenciesWithRate.append(currencyPair)
    }
}
