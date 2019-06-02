import Foundation
import CoreData

struct CurrencyPair: Hashable {
    let fromCurrencyCode: String
    let fromCurrencyName: String?
    let targetCurrencyCode: String
    let targetCurrencyName: String?
    var conversionRate: Double?
    let creationDate: Date
}

extension CurrencyPair {
    var pair: String {
        return "\(fromCurrencyCode)\(targetCurrencyCode)"
    }
    
    static func createCurrencyPair(with fromCurrency: Currency, with targetCurrency: Currency) -> CurrencyPair {
        return CurrencyPair(
            fromCurrencyCode: fromCurrency.code,
            fromCurrencyName: fromCurrency.currency,
            targetCurrencyCode: targetCurrency.code,
            targetCurrencyName: targetCurrency.currency,
            conversionRate: nil,
            creationDate: Date())
    }
}

// MARK: - Internal Model

final class ManagedCurrencyPair: NSManagedObject {
    
    
    // MARK: - Inner Types
    
    private enum Constants {
        static let entityName = "CurrencyPair"
        static let keyFromCurrencyCode = "fromCurrencyCode"
        static let keyFromCurrencyName = "fromCurrencyName"
        static let keyTargetCurrencyCode = "targetCurrencyCode"
        static let keyTargetCurrencyName = "targetCurrencyName"
        static let keyCreationDate = "creationDate"
    }
    
    
    // MARK: - Properties
    // MARK: Immutable
    
    static let entityName = Constants.entityName
    
    // MARK: Mutable & Managed
    
    @NSManaged var fromCurrencyCode: String
    @NSManaged var fromCurrencyName: String?
    @NSManaged var targetCurrencyCode: String
    @NSManaged var targetCurrencyName: String?
    @NSManaged var creationDate: Date
    
    
    //MARK: - Fetch API
    
    class func fetchRequest(code: String) -> NSFetchRequest<ManagedCurrencyPair> {
        let fetchRequest = NSFetchRequest<ManagedCurrencyPair>(entityName: Constants.entityName)
        fetchRequest.predicate = NSPredicate(format: "\(Constants.keyFromCurrencyCode) == %@", code)
        return fetchRequest
    }
    
    class func fetchRequestOrdered() -> NSFetchRequest<ManagedCurrencyPair> {
        let fetchRequest = NSFetchRequest<ManagedCurrencyPair>(entityName: Constants.entityName)
        let byCreationDate = NSSortDescriptor(key: Constants.keyCreationDate, ascending: true)
        fetchRequest.sortDescriptors = [byCreationDate]
        return fetchRequest
    }
    
    class func fetchRequest(fromCurrencyCode: String, targetCurrency: String) -> NSFetchRequest<ManagedCurrencyPair> {
        let fetchRequest = NSFetchRequest<ManagedCurrencyPair>(entityName: Constants.entityName)
        fetchRequest.predicate = NSPredicate(format: "\(Constants.keyFromCurrencyCode) == %@ AND \(Constants.keyTargetCurrencyCode) == %@", fromCurrencyCode as CVarArg, targetCurrency as CVarArg)
        return fetchRequest
    }
}

