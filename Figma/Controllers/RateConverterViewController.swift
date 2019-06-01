import UIKit

protocol RateConverterViewControllerDelegate: AnyObject {
    func addCurrency()
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
        button.setTitleColor(.blue, for: .normal)
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
        
        start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func start() {
        viewModel.fetchSavedCurrenciesPair()
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSubviews()
        setupConstraints()
        setupDataObserving()
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
    
    private func setupDataObserving() {
        viewModel.refeshTableView = { [weak self] in
            DispatchQueue.main.sync {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Action
    
    @objc func addCurrency() {
        coordinatorDelegate?.addCurrency()
    }
}

extension RateConverterViewController: UITableViewDataSource {
    
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
    
}
