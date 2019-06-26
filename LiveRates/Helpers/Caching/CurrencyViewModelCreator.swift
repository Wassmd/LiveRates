import Foundation

final class CurrencyViewModelCreator {
    
    
    // MARK: Mutable
    
    private(set) var itemViewModels = [IndexPath: CurrencyItemViewModel]()
    
    
    // MARK: - Actions
    
    private func makeItemViewModel(for currency: Currency, at indexPath: IndexPath) -> CurrencyItemViewModel {
        let itemViewModel = CurrencyItemViewModel(currency: currency, indexPath: indexPath)
        itemViewModels[indexPath] = itemViewModel
        return itemViewModel
    }
    
    func itemViewModel(for currency: Currency, at indexPath: IndexPath) -> CurrencyItemViewModel {
        let itemViewModel = itemViewModels[indexPath] ?? makeItemViewModel(for: currency, at: indexPath)
        
        return itemViewModel
    }
}
