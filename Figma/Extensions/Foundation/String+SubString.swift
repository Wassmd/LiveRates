import Foundation

extension String {
     func fromCurrencyCode() -> Substring {
        let upperBound = String.Index.init(utf16Offset: 3, in: self)
        let code = self[self.startIndex..<upperBound]
        return code
    }
    
    func targetCurrencyCode() -> Substring {
        let lowerBound = String.Index.init(utf16Offset: 3, in: self)
        let code = self[lowerBound..<self.endIndex]
        return code
    }
}
