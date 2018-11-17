//
//  NetworkManager.swift
//  NetworkLayer
//
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "network_authentication_error"
    case badRequest = "network_bad_request"
    case outdated = "network_outdated"
    case failed = "network_failed"
    case noData = "network_no_data"
    case unableToDecode = "network_unable_to_decode"
    case noResponseObject = "network_no_response_object"
}

enum Result<String>{
    case success
    case failure(String)
}

protocol CountriesNetworkManager {
    init(environment: NetworkEnvironment)
    /**
     Fetched Countries data based on RESTCountries API
     - Parameter completion: block to handle the fetch results
     */
    func getCountries(section: String, apiKey: String, completion: @escaping (_ countries: [Country]?,_ error: String?)->())
}

class NetworkManager: CountriesNetworkManager {
    static var environment : NetworkEnvironment = .production
    let router = Router<RESTCountriesApi>()
    
    required init(environment: NetworkEnvironment) {
        NetworkManager.environment = environment
    }
    
    
    /**
     Fetched Countries data based on RESTCountries API
     - Parameter completion: block to handle the fetch results
     */
    func getCountries(section: String, apiKey: String, completion: @escaping (_ countries: [Country]?,_ error: String?)->()) {
        router.request(.getCountries()) { data, response, error in
            let result = self.handleNetworkResponse(data: data, response: response, error: error)
            switch result{
            case .success:
                do {
                    /*let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    print(jsonData)*/
                    let apiResponse = try JSONDecoder().decode(CountriesAPIResponse.self, from: data!)
                    completion(apiResponse.countries, nil)
                }catch {
                    print(error)
                    completion(nil, NetworkResponse.unableToDecode.rawValue)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    
    /**
     Handle all basic network error responses
     */
    fileprivate func handleNetworkResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<String>{
        if error != nil {
            return .failure("Please check your network connection.")
        }
        
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200...299:
                print("HTTPURLResponse: success")
            case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
            case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
            case 600: return .failure(NetworkResponse.outdated.rawValue)
            default: return .failure(NetworkResponse.failed.rawValue)
            }
        }
        
        guard data != nil else {
            return .failure(NetworkResponse.noData.rawValue)
        }
        
        return .success
    }
}
