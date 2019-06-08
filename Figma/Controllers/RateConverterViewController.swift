import UIKit

protocol RateConverterViewControllerDelegate: AnyObject {
    func addCurrency()
    func errorAlert(with error: Error)

}

class RateConverterViewController: UIViewController {
    
    
    // MARK: - Inner Types
    
    private enum Constants {
        static let tableTopOffset: CGFloat = 12.0
        static let tableBottomOffset: CGFloat = 19.0
        static let rateRowHeight: CGFloat = 80
        static let buttonTitle = "Add currency pair"
        static let navigationTitle = "Rates & converter"
        static let contentInnerVerticalSpacing: CGFloat = 8
        static let actionButtonHeight: CGFloat = 72
        static let buttonTitleInsets = UIEdgeInsets(top: 0, left: 27, bottom: 0, right: 0)
        static let buttonImageInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        static let buttonTitleFont: UIFont = UIFont(name: "Roboto-Regular", size: 16)!
    }
    
    
    // MARK: - Properties
    // MARK: Immutable
    
    let viewModel: RateConverterViewModel
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.registerReusableCell(RateTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    
    private let actionButton: UIButton = {
        let button = ViewCreationHelper.createImageButton(image: #imageLiteral(resourceName: "Plus"), titleFont: Constants.buttonTitleFont, height: Constants.actionButtonHeight, titleInsets: Constants.buttonTitleInsets)
        button.setTitle(Constants.buttonTitle, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.imageEdgeInsets = Constants.buttonImageInsets
        return button
    }()
    
    
    // MARK: Mutable
    
    var coordinatorDelegate: RateConverterViewControllerDelegate?
    
    
    //MARK: - Initializers
    
    init(viewModel: RateConverterViewModel,
         coordinatorDelegate: RateConverterViewControllerDelegate?) {
        self.viewModel = viewModel
        self.coordinatorDelegate = coordinatorDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSubviews()
        setupConstraints()
        setupObserving()
        
        viewModel.start()
    }
    
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = Constants.navigationTitle
        navigationItem.hidesBackButton = true
    }
    
    private func setupSubviews() {
        view.addSubview(actionButton)
        view.addSubview(tableView)
        actionButton.addTarget(self, action: #selector(addCurrency), for: .touchUpInside)
    }
    
    private func  setupConstraints() {
        actionButton.pinLeadingAndTrailingEdges(to: view)
        actionButton.pinTopEdge(to: view.safeAreaLayoutGuide)
        actionButton.pinHeight(to: Constants.actionButtonHeight)
        tableView.pinTopEdgeToBottom(of: actionButton)
        tableView.pinLeadingAndTrailingEdges(to: view)
        tableView.pinBottomEdge(to: view.safeAreaLayoutGuide, withOffset: -Constants.tableBottomOffset)
    }
    
    private func setupObserving() {
        viewModel.refeshTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.handleError = { [weak self] error in
            DispatchQueue.main.async {
                self?.coordinatorDelegate?.errorAlert(with: error)
            }
        }
        
        viewModel.addNewCurrencyOnTop = { [weak self] in
            DispatchQueue.main.async {
                self?.insertNewCurrenyOnTop()
            }
        }
    }
    
    
    // MARK: - Action
    
    @objc func addCurrency() {
        coordinatorDelegate?.addCurrency()
    }
    
    private func insertNewCurrenyOnTop() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: .top)
            self.tableView.endUpdates()
            self.viewModel.updateIsNewCurrencyPairAdded(false)
        
//        }
    }
}

extension RateConverterViewController: UITableViewDataSource {
    
    
    // MARK: - Protocol Conformance
    // MARK: UITableViewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sortedCurrenciesWithRate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RateTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        if let currencyPair = viewModel.sortedCurrenciesWithRate[safe: indexPath.row] {
            cell.configureCell(with: currencyPair)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rateRowHeight
    }
}

extension RateConverterViewController: UITableViewDelegate {
    
    
    // MARK: - Protocol Conformance
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delectAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] ( action, view, success: (Bool) -> Void) in
            do {
                try self?.viewModel.deleteCurrencyPair(at: indexPath)
                success(true)
            } catch let error {
                success(false)
                print("Row could not be deleted:\(error)")
            }
        }
        return UISwipeActionsConfiguration(actions: [delectAction])
    }
}
