import Foundation

final class CurrencyItemViewModel {
    
    
    // MARK: - Properties
    // MARK: Immutable
    
    let indexPath: IndexPath
    let currency: Currency
    
    
    // MARK: Immutable
    
    var isSelected: Bool = false
    var cellType: CurrencyCell.CellType
    
    // MARK: - Initializers
    
    init(currency: Currency,
         indexPath: IndexPath,
         cellType: CurrencyCell.CellType = CurrencyCell.CellType.standard) {
        self.currency = currency
        self.indexPath = indexPath
        self.cellType = cellType
    }
    
    
    // MARK: Helper
    
    func updateSelectionState() {
        isSelected = !isSelected
        print("Wasim ----- code:\(currency.code) isSelected:\(isSelected)")
    }
    
    func updateCellType(cellType: CurrencyCell.CellType) {
        self.cellType = cellType
    }
}
