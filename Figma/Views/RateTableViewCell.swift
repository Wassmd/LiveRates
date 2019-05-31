import UIKit

class RateTableViewCell: UITableViewCell {

    
    // MARK: - Inner Types
    
    private enum Constants {
        static let iconImageLeadingOffset: CGFloat = 16
        static let iconSize: CGSize = CGSize(squareLength: 24)
        static let offset: CGFloat = 16
        static let currancyLabelLeadingOffset: CGFloat = 18
        static let fromCurrencyValueFont: UIFont = UIFont.roboto(withSize: 20)
        static let fromCurrencyNameFont: UIFont = UIFont.roboto(withSize: 14)
        static let toCurrencyValueFont: UIFont = UIFont.roboto(withSize: 20)
        static let toCurrencyNameCodeFont: UIFont = UIFont.roboto(withSize: 14)
        static let labelWidth: CGFloat = 124
    }
    
    // MARK: - Properties
    // MARK: Immutable
    
    private let fromCurrencyValueCodeLabel = ViewCreationHelper.createLabel(font: Constants.fromCurrencyValueFont, textColor: .black)
    private let fromCurrencyNameLabel = ViewCreationHelper.createLabel(font: Constants.fromCurrencyNameFont, textColor: .lightGray)
    private let toCurrencyValueLabel = ViewCreationHelper.createLabel(font: Constants.toCurrencyValueFont, textColor: .black, textAlignment: .right)
    private let toCurrencyCodeLabel = ViewCreationHelper.createLabel(font: Constants.toCurrencyNameCodeFont, textColor: .lightGray, textAlignment: .right)
    
    
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
    
    private func setupViews() {
        selectedBackgroundView = nil
        contentView.backgroundColor = .white
        backgroundColor = .clear
    }
    
    private func setupSubviews() {
        addSubview(fromCurrencyValueCodeLabel)
        addSubview(fromCurrencyNameLabel)
        addSubview(toCurrencyValueLabel)
        addSubview(toCurrencyCodeLabel)
    }
    
    private func setupConstraints() {
        fromCurrencyValueCodeLabel.pinLeadingEdge(to: self, withOffset: Constants.offset)
        fromCurrencyValueCodeLabel.pinTopEdge(to: self, withOffset: 16)
        fromCurrencyValueCodeLabel.pinWidth(to: Constants.labelWidth)
        
        fromCurrencyNameLabel.pinLeadingEdge(to: self, withOffset: Constants.offset)
        fromCurrencyNameLabel.pinTopEdgeToBottom(of: fromCurrencyValueCodeLabel , withOffset: 8)
        fromCurrencyNameLabel.pinWidth(to: Constants.labelWidth)
      
        toCurrencyValueLabel.pinTrailingEdge(to: self, withOffset: -Constants.offset)
        toCurrencyValueLabel.pinTopEdge(to: self, withOffset: 17)
        toCurrencyValueLabel.pinWidth(to: Constants.labelWidth)
        
        toCurrencyCodeLabel.pinTrailingEdge(to: self, withOffset: -Constants.offset)
        toCurrencyCodeLabel.pinTopEdgeToBottom(of: toCurrencyValueLabel, withOffset: 8)
        toCurrencyCodeLabel.pinWidth(to: Constants.labelWidth)
        
    }
    
    func configureCell(with currencyPair: CurrencyPair) {
        if let value = currencyPair.conversionRate {
            toCurrencyValueLabel.text = "\(value)"
        } else {
            toCurrencyValueLabel.text = "---"
        }
        fromCurrencyValueCodeLabel.text = "1 \(currencyPair.fromCurrencyCode)"
        fromCurrencyNameLabel.text = currencyPair.fromCurrencyName
        
        toCurrencyCodeLabel.text = "\(currencyPair.fromCurrencyName ?? "")  \(currencyPair.targetCurrencyCode) "
    }
}
