import Foundation
import Nimble
import XCTest
@testable import Figma

class RateConverterViewModelTests: XCTestCase {
    
    
    // MARK: - Properties
    // MARK: Mutable
    
    private var viewModel: RateConverterViewModel!
    private var networkServiceMock: NetworkServiceMock!
    private var currencyPairServiceMock: CurrencyPairServiceMock!
    
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        
        setupMocks()
    }
    
    
    // MARK: - Setups
    
    private func setupMocks() {
        networkServiceMock = NetworkServiceMock()
        currencyPairServiceMock = CurrencyPairServiceMock()
        viewModel = RateConverterViewModel(
            networkService: networkServiceMock,
            currencyPairService: currencyPairServiceMock)
    }
    
    func testSetUpInitialData_shouldBeCalled() {
        expect(self.currencyPairServiceMock.calledCount.fetchCurrenciesPairFromLocalDatabase).to(equal(1))
    }
    
    func testSetUpInitialData_fetchCurrenciesPairFromLocalDatabase_shouldBeCalled() {
        currencyPairServiceMock.returnValue.currenciesPair = createCurrencyPairs()
        
        viewModel.syncCurrenciesPairWithLocalDatabase()
        
         expect(self.currencyPairServiceMock.calledCount.fetchCurrenciesPairFromLocalDatabase).to(equal(2))
        expect(self.viewModel.sortedCurrenciesWithRate.count).to(equal(2))
    }
    
    func testFetchConversionRates_fetchConverstionIsCalled_returnRateDict() {
        networkServiceMock.returnValue.pairsDict =  ["CZKUSD":0.0443,"GBPPLN":5.0251]
        
        viewModel.updateSortedCurrenciesWithRate(with: createCurrencyPairs())
        
        viewModel.fetchConversionRates()
        
        expect(self.networkServiceMock.calledCount.fetchConvertionRatesCount).to(equal(1))
        let rate = viewModel.sortedCurrenciesWithRate.first { $0.conversionRate == 0.0443 }
        let rate2 = viewModel.sortedCurrenciesWithRate.first { $0.conversionRate == 5.0251 }
        
        expect(rate).notTo(beNil())
        expect(rate2).notTo(beNil())
    }
    
    func testUpdateConversationRates_ofExistingCurrencyPairs_shouldUpdateToNewValue() {
        viewModel.updateSortedCurrenciesWithRate(with: createCurrencyPairs())
        networkServiceMock.returnValue.pairsDict =  ["CZKUSD":1.7777,"GBPPLN":23.23]
        
        viewModel.fetchConversionRates()
        
        let rate = viewModel.sortedCurrenciesWithRate.first { $0.conversionRate == 1.7777 }
        let rate2 = viewModel.sortedCurrenciesWithRate.first { $0.conversionRate == 23.23 }
        
        expect(rate).notTo(beNil())
        expect(rate2).notTo(beNil())
    }
    
    
    // MARK: - Helper
    
    private func createCurrencyPairs() -> [CurrencyPair] {
        let currencyPair1 = CurrencyPair(fromCurrencyCode: "CZK", fromCurrencyName:  nil, targetCurrencyCode: "USD", targetCurrencyName: nil, conversionRate: 0.0443, creationDate:  Date())
        let currencyPair2 = CurrencyPair(fromCurrencyCode: "GBP", fromCurrencyName:  "British Pound", targetCurrencyCode: "PLN", targetCurrencyName: "Polish Zloty", conversionRate: 5.0251, creationDate:  Date())
        
        return [currencyPair1, currencyPair2]
    }
}
