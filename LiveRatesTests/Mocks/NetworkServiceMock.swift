import Foundation
import Nimble
import XCTest
@testable import LiveRates

class NetworkServiceMock: NetworkService {
    
    class CalledCount {
        var fetchConvertionRatesCount = 0
    }
    
    class ReturnValue {
        var pairsDict = [String: Any]()
    }
    
    
    // MARK: - Properties
    // MARK: Immutable
    
    let calledCount = CalledCount()
    let returnValue = ReturnValue()
    
    override func fetchConvertionRates(with pairs: [String], completion: @escaping ((Dictionary<String, Any>?, Error?) -> Void)) {
        calledCount.fetchConvertionRatesCount += 1
        completion(self.returnValue.pairsDict, nil)
    }
    
}
