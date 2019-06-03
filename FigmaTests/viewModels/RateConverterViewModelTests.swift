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
        
    }
    
    func testSetUpInitialData_fetchCurrenciesPairFromLocalDatabase_shouldBeCalled() {
        viewModel.setupSavedCurrenciesPairs()
        
         expect(self.currencyPairServiceMock.calledCount.fetchCurrenciesPairFromLocalDatabase).to(equal(2))
        
        expect(self.viewModel.sortedCurrenciesWithRate.count).to(equal(2))
        let rate = viewModel.sortedCurrenciesWithRate.first { $0.conversionRate == 0.0443 }
        let rate2 = viewModel.sortedCurrenciesWithRate.first { $0.conversionRate == 5.0251 }
        print("\(viewModel.sortedCurrenciesWithRate)")

        expect(rate).notTo(beNil())
        expect(rate2).notTo(beNil())
        
    }
    
    func testFetchConversionRates_fetchConverstionIsCalled_returnRateDict() {
        let currencyPair = CurrencyPair(fromCurrencyCode: "CZK", fromCurrencyName:  nil, targetCurrencyCode: "USD", targetCurrencyName: nil, conversionRate: nil, creationDate:  Date())
        let currencyPair2 = CurrencyPair(fromCurrencyCode: "GBP", fromCurrencyName:  nil, targetCurrencyCode: "PLN", targetCurrencyName: nil, conversionRate: nil, creationDate:  Date())
        viewModel.sortedCurrenciesWithRate.append(currencyPair)
        viewModel.sortedCurrenciesWithRate.append(currencyPair2)
        
        viewModel.fetchConversionRates()
        
        expect(self.networkServiceMock.calledCount.fetchConvertionRates).to(equal(1))
        
        let rate = viewModel.sortedCurrenciesWithRate.first { $0.conversionRate == 0.0443 }
        let rate2 = viewModel.sortedCurrenciesWithRate.first { $0.conversionRate == 5.0251 }
        
        expect(rate).notTo(beNil())
        expect(rate2).notTo(beNil())
    }
}
