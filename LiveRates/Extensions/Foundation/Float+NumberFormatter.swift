import Foundation

extension Float {
    
    var formattedCurrencyValue: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        if let string = formatter.string(from: NSNumber(value: self)) {
            return string
        }
        return nil
    }
}
