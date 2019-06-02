import UIKit

enum Constants {
    static let tableTopOffset: CGFloat = 12.0
    static let tableBottomOffset: CGFloat = 19.0
    static let rowHeight: CGFloat = 56
}

class BaseCurrencyViewController<ViewModelType: BaseCurrencyViewModel>: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: - Properties
    // MARK: Immutable
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        tableView.registerReusableCell(CurrencyCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    let viewModel: ViewModelType
    
    
    // MARK: Mutable
    
    var indexPath: IndexPath?
    
    
    // MARK: - Initializers
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        loadSupportedCurrencies()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    
    // MARK: - Setups
    
    private func loadSupportedCurrencies() {
        viewModel.setupInitialData { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
    }
    
    private func  setupConstraints() {
        tableView.pinTopEdge(to: view.safeAreaLayoutGuide, withOffset: Constants.tableTopOffset)
        tableView.pinLeadingAndTrailingEdges(to: view)
        tableView.pinBottomEdge(to: view.safeAreaLayoutGuide, withOffset: -Constants.tableBottomOffset)
    }
    
    
     // MARK: - Transitions
    
    func userSelectedCurrency(indexPath: IndexPath) {
        assertionFailure("Should be overriden by subclass")
    }
    
    
    // MARK: - Protocol Conformance
    // MARK: UITableViewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSupportedCurrencies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyCell = tableView.dequeueReusableCell(indexPath: indexPath)
        let itemVieModel = viewModel.itemViewModel(for: indexPath)
        cell.viewModel = itemVieModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemViewModel = viewModel.itemViewModel(for: indexPath)
        userSelectedCurrency(indexPath: indexPath)
    }
}
