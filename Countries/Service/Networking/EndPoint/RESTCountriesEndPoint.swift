//
//  RESTCountriesEndPoint.swift
//  NetworkLayer
//
//

import Foundation


public enum RESTCountriesApi {
    case getCountries()
}

extension RESTCountriesApi: EndPointType {
    /** API base urls. */
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production:
            return "https://restcountries.eu/"
        default:
            return "https://restcountries.eu/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    /** API path for specific request. */
    var path: String {
        switch self {
        case .getCountries:
            return "rest/v2/all"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    /** generate task based on requested RESTCountries API. */
    var task: HTTPTask {
        switch self {
        case .getCountries:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}



