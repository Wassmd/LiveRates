import Foundation

class BaseCurrencyViewModel {
    
        
    //MARK: Properties
    //MARK: Immutables
    
    let viewModelCreator: CurrencyViewModelCreator
    private let currencies =  [Currency]()
    private let currencyHelper: CurrencyHelper

    
    // MARK: Mutable
    
    var supportedCurrencies = [Currency]()
    
    //MARK: - Initializers
    
    init(viewModelCreator: CurrencyViewModelCreator = .init(),
         currencyHelper: CurrencyHelper = CurrencyHelper()) {
        self.viewModelCreator = viewModelCreator
        self.currencyHelper = currencyHelper
    }
    
    
    // MARK: Setup
    
    func setupInitialData(completion: (() -> Void)) {
        supportedCurrencies = currencyHelper.fetchSupportedCurrencies()
        completion()
    }
    
    
   
    // MARK: - API
    
    func itemViewModel(for indexPath: IndexPath) -> CurrencyItemViewModel {
        let currency = getCurrency(at: indexPath)
        return viewModelCreator.itemViewModel(for: currency, at: indexPath)
    }
    

    // MARK: - Helper
    
    func getCurrency(at indexPath: IndexPath) -> Currency {
        return supportedCurrencies[safe: indexPath.row].require(hint: "There should always be a currency for a given index path, since underlying data is the same! IndexPath: \(indexPath)")
    }
    
    func numberOfSupportedCurrencies() -> Int {
        return supportedCurrencies.count
    }
    
    func indexPath(of currency: Currency) -> IndexPath? {
        guard let index = supportedCurrencies.firstIndex(of: currency) else { return nil }
        return IndexPath(row: index, section: 0)
    }
}
