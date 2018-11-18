//
//  CountriesViewModelTests.swift
//  CountriesTests
//
//  Created by Christian  Huang on 18/11/18.
//  Copyright © 2018 Christian Huang. All rights reserved.
//

import XCTest
@testable import Countries

class CountriesViewModelTests: XCTestCase {
    
    var networkManager = MockNetworkManager(environment: .qa)
    var countriesViewModel = CountriesViewModel()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        countriesViewModel.networkManager = networkManager
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testFetchCountriesError() {
        networkManager.mockError = "This is an error"
        networkManager.mockCountries = nil
        
        countriesViewModel.fetchCountries()
        
        XCTAssertEqual(countriesViewModel.status, networkManager.mockError?.localized())
    }
    
    func testFetchCountries() {
        let data = loadDataFromBundle(withName: "countries", extension: "json")
        let countries = try! JSONDecoder().decode([Country].self, from: data)
        networkManager.mockCountries = countries
        networkManager.mockError = nil
        
        countriesViewModel.filterCountries(keyword: "")
        countriesViewModel.fetchCountries()
        
        XCTAssertEqual(countriesViewModel.getCountriesCount(), 250)
        
    }
    
    func testFilterCountries() {
        let data = loadDataFromBundle(withName: "countries", extension: "json")
        let countries = try! JSONDecoder().decode([Country].self, from: data)
        let countryCellViewModels = countries.map({ (country) -> CountryCellViewModel in
            return CountryCellViewModel(with: country)
        })
        
        countriesViewModel.countryCellViewModels = countryCellViewModels
        
        let keywords = ["sw", "europe", "northern europe"]
        let results = [4, 53, 16]
        
        for i in 0..<keywords.count {
            countriesViewModel.filterCountries(keyword: keywords[i])
            XCTAssertEqual(countriesViewModel.getCountriesCount(), results[i])
        }
    }

}
