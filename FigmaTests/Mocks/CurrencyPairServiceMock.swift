import Foundation
import Nimble
import XCTest
@testable import Figma

class CurrencyPairServiceMock: CurrencyPairService {
    
    
    class CalledCount {
        var fetchCurrenciesPairFromLocalDatabase = 0
    }
    
    class ReturnValue {
        
    }
    
    
    // MARK: - Properties
    // MARK: Immutable
    
    let calledCount = CalledCount()
    let returnValue = ReturnValue()
    
    override func fetchCurrenciesPairFromLocalDatabase(completion: @escaping (([CurrencyPair]?, Error?) -> Void)) {
        calledCount.fetchCurrenciesPairFromLocalDatabase += 1
        
        let currencyPair1 = CurrencyPair(fromCurrencyCode: "CZK", fromCurrencyName:  nil, targetCurrencyCode: "USD", targetCurrencyName: nil, conversionRate: nil, creationDate:  Date())
        let currencyPair2 = CurrencyPair(fromCurrencyCode: "GBP", fromCurrencyName:  "British Pound", targetCurrencyCode: "PLN", targetCurrencyName: "Polish Zloty", conversionRate: nil, creationDate:  Date())
        
        completion([currencyPair1,currencyPair2], nil)
    }
}
