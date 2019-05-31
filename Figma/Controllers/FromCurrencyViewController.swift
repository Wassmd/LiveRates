import UIKit

protocol FromCurrencyViewControllerDelegate: AnyObject {
    func selectedFromCurrency(_ currency: Currency)
}

class FromCurrencyViewController: BaseCurrencyViewController<BaseCurrencyViewModel> {
    
    
    // MARK: Mutable
    
    weak var coordinatorDelegate: FromCurrencyViewControllerDelegate?
    
    
    // MARK: - Initializers
    
    init(viewModel: BaseCurrencyViewModel,
         indexPath: IndexPath? = nil,
         coordinatorDelegate: FromCurrencyViewControllerDelegate?) {
        self.coordinatorDelegate = coordinatorDelegate
        super.init(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Actions
    
    override func userSelectedCurrency(indexPath: IndexPath) {
        let currency = viewModel.getCurrency(at: indexPath)
        coordinatorDelegate?.selectedFromCurrency(currency)
    }
}
