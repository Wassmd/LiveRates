import Foundation

extension Array {
    
    /// Safely access an array element, if index out of bounds, empty element will be returned
    ///
    /// - Parameter index: index
    subscript(safe index: Int) -> Element? {
        if index >= 0 && index < count {
            return self[index]
        }
        
        return nil
    }
}
