import Foundation
import Nimble
import XCTest
@testable import Figma

class CurrencyPairServiceMock: CurrencyPairService {
    
    
    class CalledCount {
        var fetchCurrenciesPairFromLocalDatabase = 0
    }
    
    class ReturnValue {
        var currenciesPair = [CurrencyPair]()
    }
    
    
    // MARK: - Properties
    // MARK: Immutable
    
    let calledCount = CalledCount()
    let returnValue = ReturnValue()
    
    override func fetchCurrenciesPairFromLocalDatabase(completion: @escaping (([CurrencyPair]?, Error?) -> Void)) {
        calledCount.fetchCurrenciesPairFromLocalDatabase += 1
        completion(returnValue.currenciesPair, nil)
    }
}
