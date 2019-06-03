import Foundation

enum RequestError: Error {
    case unknown
    case networkError
    case invalidURL
}

enum ResponseError: Error {
    case malFunctionJson
}

class NetworkService {
    
    
    // MARK: - Inner Types
    
    enum Constants {
        static let timeout: TimeInterval = 5.0
    }
    
    private enum ResponseError: Error {
        case malFunctionJson
    }
    
    
    // MARK: Properties
    // MARK: Immutable
    
    private let config: URLSessionConfiguration
    
    
    // MARK: - initializer
    
    init() {
        self.config = URLSessionConfiguration.default
        self.config.timeoutIntervalForRequest = Constants.timeout
        self.config.timeoutIntervalForResource = Constants.timeout
        self.config.waitsForConnectivity = true
    }
    
    
    // MARK: - setup
    
    func rateConversionURL(with pairs: [String]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "europe-west1-revolut-230009.cloudfunctions.net"
        components.path = "/revolut-ios/"
        components.queryItems = pairs.map { URLQueryItem(name: "pairs", value: $0)}
        
        return components.url
    }
    
    
    // MARK: API
    
    func fetchConvertionRates(with pairs: [String] , completion: @escaping ((Dictionary<String, Any>?, Error?) -> Void)) {
        guard let url = rateConversionURL(with: pairs) else {
            completion(nil, RequestError.invalidURL)
            return
        }
        
        print("URL:\(url.absoluteString)")
        let urlRequest = URLRequest(url: url)
        let urlSession = URLSession(configuration: config)
        
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(nil, RequestError.networkError)
                return
            }
            
            if let data = data {
                do {
                    print("Response form server: \(String(describing: String(data: data, encoding: .utf8)))")
                    if let result = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        completion(result, nil)
                    }
                } catch {
                    completion(nil, ResponseError.malFunctionJson)
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
