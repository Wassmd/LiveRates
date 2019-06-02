import Foundation

final class TargetCurrencyViewModel: BaseCurrencyViewModel {
    
    
    //MARK: Properties
    //MARK: Immutables
    
    let selectedFromCurrency: Currency
    private let currencyPairService: CurrencyPairService
    private var savedCurrencyPairs = [CurrencyPair]()
    
    
    //MARK: - Initializers
    
    init(selectedFromCurrency: Currency,
         currencyPairService: CurrencyPairService = CurrencyPairService.instance) {
        self.selectedFromCurrency = selectedFromCurrency
        self.currencyPairService = currencyPairService
        
        super.init()
    }
    
   
    // MARK: - Actions
    
    func fetchSavedCurrecyPair(completion: @escaping (() -> Void)) {
        currencyPairService.fetchSavedCurrencyPair(by: selectedFromCurrency.code) { [weak self] saveCurrencyPairs, error in
            guard let self = self else { return }
            guard error == nil else { return }
            
            print("Wasim ***** \(String(describing: saveCurrencyPairs))")
            
            if let saveCurrencyPairs = saveCurrencyPairs {
                self.savedCurrencyPairs = saveCurrencyPairs
                self.updateItemViewModelCellType()
                self.updateCellTypeForSelectedFromCurrency()
            }
            completion()
        }
    }
    
    func prepareNewCurrencyPair(for indexPath: IndexPath) -> CurrencyPair{
        let targetCurrency = getCurrency(at: indexPath)
        let currencyPair = CurrencyPair.createCurrencyPair(with: selectedFromCurrency, with: targetCurrency)
        return currencyPair
    }
    
   
    // MARK: - Helpers
    
    func updateItemViewModelCellType() {
        for curreny in self.supportedCurrencies {
            let indexPath = self.indexPath(of: curreny)
            if let indexPath = indexPath {
                let itemViewModel = self.itemViewModel(for: indexPath)
                let currencyCode = itemViewModel.currency.code
                let previouslySelected = savedCurrencyPairs.compactMap { $0.targetCurrencyCode }.contains(currencyCode)
                let cellType = previouslySelected ? CurrencyCell.CellType.disabled : CurrencyCell.CellType.standard
                itemViewModel.cellType = cellType
            }
        }
    }
    
    func updateCellTypeForSelectedFromCurrency() {
        guard let indexPath = self.indexPath(of: selectedFromCurrency)
            else { return }
        
        let itemViewModel = self.itemViewModel(for: indexPath)
        itemViewModel.cellType = CurrencyCell.CellType.disabled
    }
    
    func handleTargetCurrencySelection(indexPath: IndexPath) {
        let selectedTargetCurrency = getCurrency(at: indexPath)
        let currencyPair = createCurrencyPair(with: selectedFromCurrency, with: selectedTargetCurrency)
        
        appendToSavedCurrencies(currencyPair)
    }
    
    private func appendToSavedCurrencies(_ currencyPair: CurrencyPair) {
        savedCurrencyPairs.append(currencyPair)
    }
    
    private func createCurrencyPair(
        with fromCurrency: Currency,
        with targetCurrency: Currency) -> CurrencyPair {
        return CurrencyPair(fromCurrencyCode: fromCurrency.code, fromCurrencyName: fromCurrency.currency, targetCurrencyCode: targetCurrency.code, targetCurrencyName: targetCurrency.currency, conversionRate: nil, creationDate: Date())
    }    
}
