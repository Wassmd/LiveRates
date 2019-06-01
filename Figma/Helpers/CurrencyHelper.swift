import Foundation

typealias SupportedCurrencies = [Currency]

final class CurrencyHelper {
    
    
    // MARK: - Inner Types
    
    private enum Constants {
        static let currenciesFileName = "currencies"
    }
    
    
    // MARK: - Properties
    // MARK: Immutable
    
    private let fileManagerHelper: FileManagerHelper
    
    
    // MARK: - Intializer
    
    init(fileManagerHelper: FileManagerHelper = FileManagerHelper()) {
        self.fileManagerHelper = fileManagerHelper
    }
    
    
    // MARK: Action
    
    func fetchSupportedCurrencies() -> SupportedCurrencies  {
        guard let url = retrieveFileURL() else {
            return []
        }
        
        let supportedCurrencies = fileManagerHelper.retreive(url, type: SupportedCurrencies.self)
        
        return supportedCurrencies ?? []
    }
    
    
    // MARK: Helper
    
    private func retrieveFileURL() -> URL? {
        return Bundle.main.url(forResource: Constants.currenciesFileName, withExtension: "json")
    }
    
    static func currencyDecimalValue(currencyRate: Double) -> (String, String) {
        let rateFirstPart = String(format: "%.2f", currencyRate)
        let rateFirstPartFloat = Float(rateFirstPart)?.formattedCurrencyValue
        let truncatedValue = String(format: "%.4f", currencyRate)
        let subStrings = "\(truncatedValue)".split(separator: ".")
        let firtFourDecimalDigits = String(subStrings[1])
        let lastTwoDigit = String(firtFourDecimalDigits.lastTwoCharacterFromString())
        print("Wasim rateFirstPart:\(rateFirstPart) lastTwoDigit:\(lastTwoDigit)")
        return ("\(rateFirstPartFloat ?? "----")", lastTwoDigit)
    }
}
