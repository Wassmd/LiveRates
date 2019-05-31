import UIKit

class RateConverterViewController: UIViewController {

    
    // MARK: - Inner Types
    
    private enum Constants {
        static let tableTopOffset: CGFloat = 12.0
        static let tableBottomOffset: CGFloat = 19.0
        static let rateRowHeight: CGFloat = 56
        static let buttonTitle = "Add currency pair"
        static let navigationTitle = "Rates & converter"
        static let contentInnerVerticalSpacing: CGFloat = 8
    }
    
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
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        button.setTitle(Constants.buttonTitle, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = Constants.navigationTitle
    }
    
    private func setupSubviews() {
        view.addSubview(actionButton)
        view.addSubview(tableView)
    }
    
    private func  setupConstraints() {
//        actionButton.pinSize(to: <#T##CGSize#>)
        tableView.pinTopEdge(to: view.safeAreaLayoutGuide, withOffset: Constants.tableTopOffset)
        tableView.pinLeadingAndTrailingEdges(to: view)
        tableView.pinBottomEdge(to: view.safeAreaLayoutGuide, withOffset: -Constants.tableBottomOffset)
    }
}

extension RateConverterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyCell = tableView.dequeueReusableCell(indexPath: indexPath)
//        cell.viewModel = itemVieModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rateRowHeight
    }
}

extension RateConverterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let itemViewModel = viewModel.itemViewModel(for: indexPath)
//        itemViewModel.updateSelectionState()
//        userSelectedCurrency(indexPath: indexPath)
    }
}
