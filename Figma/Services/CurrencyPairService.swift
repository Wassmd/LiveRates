import Foundation
import CoreData

class CurrencyPairService {
    
    
    // MARK: - Inner Types
    
    enum Errors: Error {
        case addError(cause: Error?)
        case fetchError(cause: Error?, message: String?)
        case removeError(cause: Error?)
    }
    
    
    // MARK: - Properties
    // MARK: Immutable
    
    static let instance = CurrencyPairService()
    
    let persistentContainer: NSPersistentContainer
    let managedObjectContext: NSManagedObjectContext
    private let notificationCenter: NotificationCenter
    
    // MARK: - Intializers
    #if TEST
    
    init(persistentContainerProvider: PersistanceContainerProviding = DefaultPersistanceContainerProvider(),
                 notificationCenter: NotificationCenter = NotificationCenter.default){
        self.persistentContainer = persistentContainerProvider.container
        self.managedObjectContext = persistentContainer.viewContext
        self.notificationCenter = notificationCenter
    }
    
    #else
    
     private init(persistentContainerProvider: PersistanceContainerProviding = DefaultPersistanceContainerProvider(),
                 notificationCenter: NotificationCenter = NotificationCenter.default){
        self.persistentContainer = persistentContainerProvider.container
        self.managedObjectContext = persistentContainer.viewContext
        self.notificationCenter = notificationCenter
    }

     #endif
    
    
    // MARK: - API

    func addCurrencyPair(currencyPair: CurrencyPair) throws {
        do {
            
            let added = (NSEntityDescription.insertNewObject(forEntityName: ManagedCurrencyPair.entityName, into: managedObjectContext) as? ManagedCurrencyPair).require(hint: "Wrong Core Data Configuration?")
            added.fromCurrencyCode = currencyPair.fromCurrencyCode
            added.fromCurrencyName = currencyPair.fromCurrencyName
            added.targetCurrencyCode = currencyPair.targetCurrencyCode
            added.targetCurrencyName = currencyPair.targetCurrencyName
            added.creationDate = currencyPair.creationDate
            try save()
            
        } catch let error {
            rollback()
            throw Errors.addError(cause: error)
        }
    }
    
    
    func fetchSavedCurrencyPair(by code: String, completion: @escaping (([CurrencyPair]?, Error?) -> Void)) {
        let context = self.persistentContainer.newBackgroundContext()
        context.perform {
            do {
                let result = try context.fetch(ManagedCurrencyPair.fetchRequest(code: code))
                    .map {  try self.asImmutable(managed: $0) }
                completion(result, nil)
            } catch let error {
                completion(nil, Errors.fetchError(cause: error, message: "Error while fetching locally saved Currency"))
            }
        }
    }
    
    func fetchCurrencyPairsFromLocalDatabase(completion: @escaping (([CurrencyPair]?, Error?) -> Void)) {
        let context = self.persistentContainer.newBackgroundContext()
        context.perform {
            do {
                let result = try context.fetch(ManagedCurrencyPair.fetchRequestOrdered())
                    .map {  try self.asImmutable(managed: $0) }
                completion(result, nil)
            } catch let error {
                completion(nil, Errors.fetchError(cause: error, message: "Error while fetching locally saved Currency"))
            }
        }
    }
    
    func remove(currencyPair: CurrencyPair) throws {
        do {
            let fetched = try fetch(currencyPair)
            managedObjectContext.delete(fetched)
            try save()
        } catch let error {
            throw Errors.removeError(cause: error)
        }
    }
    
    private func fetch(_ currencyPair: CurrencyPair) throws -> ManagedCurrencyPair {
        if let fetched = try managedObjectContext.fetch(ManagedCurrencyPair.fetchRequest(fromCurrencyCode: currencyPair.fromCurrencyCode, targetCurrency: currencyPair.targetCurrencyCode)).first {
            return fetched
        } else {
            throw Errors.fetchError(cause: nil, message: "Entity not found in persistence layer: \(currencyPair)")
        }
    }
    
    
    // MARK: - Helper
    
    private func asImmutable(managed: ManagedCurrencyPair) throws -> CurrencyPair {
        return CurrencyPair(fromCurrencyCode: managed.fromCurrencyCode,
                            fromCurrencyName: managed.fromCurrencyName,
                            targetCurrencyCode: managed.targetCurrencyCode,
                            targetCurrencyName: managed.targetCurrencyName,
                            conversionRate: nil,
                            creationDate: managed.creationDate)
        
    }
    
    private func save() throws {
        if managedObjectContext.hasChanges {
            try managedObjectContext.save()
        }
    }
    
    private func rollback() {
        managedObjectContext.reset()
    }
}


// MARK: - Supporting Types

protocol PersistanceContainerProviding {
    var container: NSPersistentContainer { get }
}

private final class DefaultPersistanceContainerProvider: PersistanceContainerProviding  {
    var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrencyPair")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unable to load persistance store: \(storeDescription) Error:\(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
