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
        static let toCurrencyFractionValueFont: UIFont = UIFont.roboto(withSize: 15)
        static let toCurrencyNameCodeFont: UIFont = UIFont.roboto(withSize: 14)
        static let labelWidth: CGFloat = 124
    }
    
    // MARK: - Properties
    // MARK: Immutable
    
    private let fromCurrencyValueCodeLabel = ViewCreationHelper.createLabel(font: Constants.fromCurrencyValueFont, textColor: .black)
    private let fromCurrencyNameLabel = ViewCreationHelper.createLabel(font: Constants.fromCurrencyNameFont, textColor: .lightGray)
    private let toCurrencyValueLabel = ViewCreationHelper.createLabel(font: Constants.toCurrencyValueFont, textColor: .black, textAlignment: .right)
     private let toCurrencyFractionValueLabel = ViewCreationHelper.createLabel(font: Constants.toCurrencyFractionValueFont, textColor: .black, textAlignment: .left)
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
        addSubview(toCurrencyFractionValueLabel)
        addSubview(toCurrencyCodeLabel)
    }
    
    private func setupConstraints() {
        fromCurrencyValueCodeLabel.pinLeadingEdge(to: self, withOffset: Constants.offset)
        fromCurrencyValueCodeLabel.pinTopEdge(to: self, withOffset: 16)
        fromCurrencyValueCodeLabel.pinWidth(to: Constants.labelWidth)
        
        fromCurrencyNameLabel.pinLeadingEdge(to: self, withOffset: Constants.offset)
        fromCurrencyNameLabel.pinTopEdgeToBottom(of: fromCurrencyValueCodeLabel , withOffset: 8)
        fromCurrencyNameLabel.pinWidth(to: Constants.labelWidth)
      
        toCurrencyValueLabel.pinTrailingEdgeToLeading(of: toCurrencyFractionValueLabel)
        toCurrencyValueLabel.pinTopEdge(to: self, withOffset: 17)
        toCurrencyValueLabel.pinWidth(to: Constants.labelWidth)
        
        toCurrencyFractionValueLabel.pinTrailingEdge(to: self, withOffset: -Constants.offset)
        toCurrencyFractionValueLabel.pinTopEdge(to: self, withOffset: 21)
        toCurrencyFractionValueLabel.pinWidth(to: 24)
        
        toCurrencyCodeLabel.pinTrailingEdge(to: self, withOffset: -Constants.offset)
        toCurrencyCodeLabel.pinTopEdgeToBottom(of: toCurrencyValueLabel, withOffset: 8)
        toCurrencyCodeLabel.pinWidth(to: 200)
        
    }
    
    func configureCell(with currencyPair: CurrencyPair) {
        fromCurrencyValueCodeLabel.text = "1 \(currencyPair.fromCurrencyCode)"
        fromCurrencyNameLabel.text = currencyPair.fromCurrencyName
        toCurrencyCodeLabel.text = "\(currencyPair.targetCurrencyName ?? "") . \(currencyPair.targetCurrencyCode)"
        
        if let value = currencyPair.conversionRate {
            toCurrencyValueLabel.text = CurrencyHelper.currencyDecimalValue(currencyRate: value).0
            toCurrencyFractionValueLabel.text = CurrencyHelper.currencyDecimalValue(currencyRate: value).1
        } else {
            toCurrencyValueLabel.text = ""
        }
    }
}
