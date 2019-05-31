import Foundation

final class CurrencyViewModel {
    
    
    // MARK: - Constants
    
    private enum Constants {
    }
    
    
    //MARK: Properties
    //MARK: Immutables
    
    private let viewModelCreator: CurrencyViewModelCreator
    private let currencies =  [Currency]()
    private let currencyHelper: CurrencyHelper
    private let selectedFromCurrency: Currency
    
    // MARK: Mutable
    
    private var supportedCurrencies = [Currency]()
    
    //MARK: - Initializers
    
    init(viewModelCreator: CurrencyViewModelCreator = .init(),
         currencyHelper: CurrencyHelper = CurrencyHelper(),
         selectedFromCurrency: Currency) {
        self.viewModelCreator = viewModelCreator
        self.currencyHelper = currencyHelper
        self.selectedFromCurrency = selectedFromCurrency
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
    
    // MARK: Helper
    
    func getCurrency(at indexPath: IndexPath) -> Currency {
        return supportedCurrencies[safe: indexPath.row].require(hint: "There should always be a currency for a given index path, since underlying data is the same! IndexPath: \(indexPath)")
    }
    
    func numberOfSupportedCurrencies() -> Int {
        return supportedCurrencies.count
    }
}
