import UIKit

class CurrencyCell: UITableViewCell {
    
    
    // MARK: - Inner Types
    
    private enum Constants {
        static let iconImageLeadingOffset: CGFloat = 16
        static let iconSize: CGSize = CGSize(squareLength: 24)
        static let codeLabelLeadingOffset: CGFloat = 16
        static let currancyLabelLeadingOffset: CGFloat = 18
        static let codeTextFont: UIFont = UIFont.systemFont(ofSize: 16)
        static let cellAlpha: CGFloat = 0.5
    }
    
    enum CellType {
        case standard
        case disabled
    }
    
    
    // MARK: - Properties
    // MARK: Immutable
    
    private let iconImageView = ViewCreationHelper.createImageView()
    private let currencyCodeLabel = ViewCreationHelper.createLabel(font: Constants.codeTextFont, textColor: .lightGray)
    private let currencyLabel = ViewCreationHelper.createLabel()
    
    
    // MARK: Mutable
    
    var type: CellType = .standard
    
    var viewModel: CurrencyItemViewModel? {
        didSet {
            configureCell(with: viewModel)
        }
    }
    
    // MARK: - Overrides
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: - Setups
    
    private func setupViews() {
//        selectedBackgroundView = nil
        contentView.backgroundColor = .white
        backgroundColor = .clear
    }
    
    private func setupSubviews() {
        addSubview(iconImageView)
        addSubview(currencyCodeLabel)
        addSubview(currencyLabel)
    }
    
    private func setupConstraints() {
        iconImageView.centerVertically(to: self)
        iconImageView.pinLeadingEdge(to: self, withOffset: Constants.iconImageLeadingOffset)
        iconImageView.pinSize(to: Constants.iconSize)
        
        currencyCodeLabel.pinLeadingEdgeToTrailingEdge(of: iconImageView, withOffset: Constants.codeLabelLeadingOffset)
        currencyCodeLabel.centerVertically(to: self)
        currencyCodeLabel.setHorizontalContentHugging(to: .defaultHigh)
        
        currencyLabel.pinLeadingEdgeToTrailingEdge(of: currencyCodeLabel, withOffset: Constants.currancyLabelLeadingOffset)
        currencyLabel.centerVertically(to: self)
        currencyLabel.pinTrailingEdge(to: self, withOffset: -Constants.currancyLabelLeadingOffset)
    }
    
    func configureCell(with itemViewModel: CurrencyItemViewModel?) {
        guard let itemViewModel = itemViewModel else { return }
        
        iconImageView.image = #imageLiteral(resourceName: "\(itemViewModel.currency.country)")
        currencyCodeLabel.text = itemViewModel.currency.code
        currencyLabel.text = itemViewModel.currency.currency
        
        updateView(for: itemViewModel.cellType)
    }
    
    
    // MARK: Helper
    
    private func updateView(for type: CellType) {
        self.type = type
        
        switch type {
        case .standard:
            contentView.backgroundColor = .white
            isUserInteractionEnabled = true
        case .disabled:
            self.alpha = Constants.cellAlpha
            isUserInteractionEnabled = false
        }
        self.layoutIfNeeded()
    }
}
