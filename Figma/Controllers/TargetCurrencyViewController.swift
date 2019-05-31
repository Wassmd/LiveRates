import UIKit

protocol ToCurrencyViewControllerDelegate: AnyObject {
    func selectedTargetCurrency(_ currency: Currency)
}

class TargetCurrencyViewController: BaseCurrencyViewController {
    
    // MARK: Mutable
    
    weak var coordinatorDelegate: ToCurrencyViewControllerDelegate?
    
    // MARK: - Initializers
    
    init(viewModel: CurrencyViewModel = CurrencyViewModel(),
         indexPath: IndexPath? = nil,
         coordinatorDelegate: ToCurrencyViewControllerDelegate?) {
        self.coordinatorDelegate = coordinatorDelegate
        super.init(viewModel: viewModel, indexPath: indexPath)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Actions
    
    override func userSelectedCurrency(indexPath: IndexPath) {
        let currency = viewModel.itemViewModel(for: indexPath).currency
        coordinatorDelegate?.selectedTargetCurrency(currency)
    }
}
