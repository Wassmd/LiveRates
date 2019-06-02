import UIKit

protocol TargetCurrencyViewControllerDelegate: AnyObject {
    func selectedTargetCurrency(_ newCurrencyPair: CurrencyPair)
    func maxPairingAchieved()
    func infoAlert(with message: String)
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
                self.showInfomativeAlertIfNeed()
            }
        }
    }
    
    override func userSelectedCurrency(indexPath: IndexPath) {
        let newCurrencyPair = viewModel.prepareNewCurrencyPair(for: indexPath)
        coordinatorDelegate?.selectedTargetCurrency(newCurrencyPair)
        
    }
    
    // MARK: Transition
    
    private func showInfomativeAlertIfNeed() {
       let maxCombinationDone = viewModel.savedCurrencyPairs.count + 1
        if maxCombinationDone == viewModel.getAllItemModelsCount() {
            coordinatorDelegate?.infoAlert(with: "You have created all posiible pairs.")
            
//            let alertController = UIAlertController(title: "Figma", message: "You have created all posiible pairs.", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
//                self.coordinatorDelegate?.maxPairingAchieved()
//            }
//
//            alertController.addAction(okAction)
//            present(alertController, animated: true, completion: nil)
        }
    }
}
