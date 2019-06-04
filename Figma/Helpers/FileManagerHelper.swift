import Foundation

final class FileManagerHelper {
    
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decorder: JSONDecoder
    
    init(fileManager: FileManager = FileManager(),
         encoder: JSONEncoder = JSONEncoder(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.fileManager = FileManager()
        self.encoder = encoder
        self.decorder = decoder
    }
    
    
    // MARK: - Actions
    
    func retreive<Element: Decodable>(_ fileURL: URL, type: Element.Type = Element.self) -> Element? {
        do {
            let element: Element = try decode(at: fileURL)
            return element
        }catch {
            return nil
        }
    }
    
    
    // MARK: - Helpers
    
    private func decode<Element: Decodable>(at url: URL) throws -> Element {
        if !fileManager.fileExists(atPath: url.path) {
            throw FileNotFoundError()
        }
        
        if let data = fileManager.contents(atPath: url.path) {
            return try decorder.decode(Element.self, from: data)
        } else {
            throw DecodingError()
        }
    }
}
