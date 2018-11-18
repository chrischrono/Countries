//
//  MockNetworkManager.swift
//  CountriesTests
//
//  Created by Christian  Huang on 18/11/18.
//  Copyright © 2018 Christian Huang. All rights reserved.
//

import Foundation
@testable import Countries


class MockNetworkManager: CountriesNetworkManager {
    var mockCountries: [Country]?
    var mockError: String?
    
    required init(environment: NetworkEnvironment) {
    }
    
    func fetchCountries(completion: @escaping ([Country]?, String?) -> ()) {
        completion(mockCountries, mockError)
    }
    
    
}
