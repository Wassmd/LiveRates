import Foundation
import Nimble
import XCTest
@testable import Figma

class NetworkServiceMock: NetworkService {
    
    class CalledCount {
        var fetchConvertionRates = 0
    }
    
    class ReturnValue {
        
    }
    
    
    // MARK: - Properties
    // MARK: Immutable
    
    let calledCount = CalledCount()
    let returnValue = ReturnValue()
    
    override func fetchConvertionRates(with pairs: [String], completion: @escaping ((Dictionary<String, Any>?, Error?) -> Void)) {
        calledCount.fetchConvertionRates += 1
        completion(["CZKUSD":0.0443,"GBPPLN":5.0251], nil)
    }
    
}
