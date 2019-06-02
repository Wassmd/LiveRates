import UIKit

protocol TargetCurrencyViewControllerDelegate: AnyObject {
    func selectedTargetCurrency(_ newCurrencyPair: CurrencyPair)
}

class TargetCurrencyViewController: BaseCurrencyViewController<TargetCurrencyViewModel> {

    // MARK: Mutable
    
    weak var coordinatorDelegate: TargetCurrencyViewControllerDelegate?
    
    // MARK: - Initializers
    
    init(viewModel: TargetCurrencyViewModel,
         coordinatorDelegate: TargetCurrencyViewControllerDelegate?) {
        self.coordinatorDelegate = coordinatorDelegate
        super.init(viewModel: viewModel)
        
        fetchSavedCurrency()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    
    func fetchSavedCurrency() {
        viewModel.fetchSavedCurrecyPair {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func userSelectedCurrency(indexPath: IndexPath) {
        let newCurrencyPair = viewModel.prepareNewCurrencyPair(for: indexPath)
        coordinatorDelegate?.selectedTargetCurrency(newCurrencyPair)
        
    }
}
