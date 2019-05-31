import Foundation

final class TargetCurrencyViewModel: BaseCurrencyViewModel {
    
    
    //MARK: Properties
    //MARK: Immutables
    
    let selectedFromCurrency: Currency
    private let currencyPairService: CurrencyPairService
    private var savedCurrencyPairs = [CurrencyPair]()
    private let onboardingStateMachine: OnboardingStateMachine
    private let notificationCenter: NotificationCenter
    
    
    //MARK: - Initializers
    
    init(selectedFromCurrency: Currency,
         currencyPairService: CurrencyPairService = CurrencyPairService.instance,
         onboardingStateMachine: OnboardingStateMachine = OnboardingStateMachine(),
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.selectedFromCurrency = selectedFromCurrency
        self.currencyPairService = currencyPairService
        self.notificationCenter = notificationCenter
        self.onboardingStateMachine = onboardingStateMachine
        super.init()
        
        setupObserving()
    }
    
    
    // MARK: setupObserving
    
    private func setupObserving() {
        notificationCenter.addObserver(self, selector: #selector(pairSaved), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
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
    
    func persisCurrencyPair(for indexPath: IndexPath) {
        let targetCurrency = getCurrency(at: indexPath)
        let currencyPair = CurrencyPair.createCurrencyPair(with: selectedFromCurrency, with: targetCurrency)
        do {
            try currencyPairService.addCurrencyPair(currencyPair: currencyPair)
        } catch let error {
            print(error)
        }
    }
    
    @objc func pairSaved() {
        print("Wasim pairSaved")
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
        return CurrencyPair(fromCurrencyCode: fromCurrency.code, fromCurrencyName: fromCurrency.currency, targetCurrencyCode: targetCurrency.code, targetCurrencyName: targetCurrency.currency, conversionRate: nil)
    }
    
    func persistOnboardingShown() {
        onboardingStateMachine.persistOnboardingShown()
    }
}
