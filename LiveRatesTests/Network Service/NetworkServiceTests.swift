import Foundation
import Foundation
import Nimble
import XCTest
import OHHTTPStubs

@testable import LiveRates

class NetworkServiceTests: XCTestCase {
    
    private var networkService: NetworkService!
    var sut: URLSession!
    override func setUp() {
        super.setUp()
        networkService = NetworkService()
        sut = URLSession(configuration: .default)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testRateConversionURL_withSinglePair() {
        let pair = "EURUSD"
        let expectedURL = URL(string: "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios/?pairs=\(pair)")
        
        expect(self.networkService.rateConversionURL(with: [pair])).to(equal(expectedURL))
    }
    
    func testFetchConvertionRates_fetchCurrentRates() {
        let path = "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios/?pairs=CZKUSD"
        
        stub(condition: isPath(path)) { request in
            let stubPath = OHPathForFile("response.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        let pairs = ["CZKUSD","GBPPLN","GBPDKK","GBPSEK"]
        let promise = expectation(description: "Get rates of pairs")
        networkService.fetchConvertionRates(with: pairs) { dict, error in
            promise.fulfill()
            XCTAssertNotNil(dict, "TEST CASE FAILED: rates are nil");
            XCTAssertNil(error, "TEST CASE FAILED: There is error in response");
        }
        
        waitForExpectations(timeout: NetworkService.Constants.timeout, handler: nil)
    }
}
