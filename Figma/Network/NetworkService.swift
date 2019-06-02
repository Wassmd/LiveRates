import Foundation

class NetworkService {
    
    typealias responseDictionary = [String: Any]
    
    
    // MARK: - Inner Types
    
    private enum Constants {
        static let timeout: TimeInterval = 10.0
    }
    
    private enum RequestError: Error {
        case unknown
        case serverError
        case connectionFailed
        case illegalParams
        case invalidAPIKey
    }
    
    private enum ResponseError: Error {
        case malFunctionJson
        case noPhotosAvailable
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
    
    func fetchRatesRequest(with pairs: [String] , completion: @escaping ((Dictionary<String, Any>?, Error?) -> Void)) {
        guard let url = rateConversionURL(with: pairs) else {
            print("Error:\(RequestError.illegalParams)")
            return
        }
        print("Request URL: \(url.absoluteString)")
        
        let urlRequest = URLRequest(url: url)
        let urlSession = URLSession(configuration: config)
        
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    print("Response form server: \(String(describing: String(data: data, encoding: .utf8)))")
                    if let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print(result)
                        completion(result, nil)
                    }
                }catch {
                    print(ResponseError.malFunctionJson)
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
}
