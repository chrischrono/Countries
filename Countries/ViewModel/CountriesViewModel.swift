//
//  CountriesViewModel.swift
//  Countries
//
//  Created by Christian  Huang on 17/11/18.
//  Copyright © 2018 Christian Huang. All rights reserved.
//

import UIKit

class CountriesViewModel: NSObject {
    private var countries = [Country]()
    var countryCellViewModels: [CountryCellViewModel] = []
    var filteredCountryCellViewModels: [CountryCellViewModel] = [] {
        didSet {
            reloadCountriesTableViewClosure?()
        }
    }
    private var keyword: String = ""
    
    /** hold the network manager for RESTCountries's API */
    var networkManager: CountriesNetworkManager = NetworkManager(environment: .production)
    
    var isLoading: Dynamic<Bool> = Dynamic(false)
    var status: String?
    
    /** closure to reload CountriesTableView */
    var reloadCountriesTableViewClosure: (()->())?
    /** closure to show CountryDetail */
    var showCountryDetailClosure: ((CountryDetailViewModel)->())?
}

extension CountriesViewModel {
    
    func fetchCountries() {
        guard isLoading.value == false && countries.count == 0 else {
            return
        }
        
        isLoading.value = true
        updateStatus("network_loading")
        
        networkManager.fetchCountries { (countries, error) in
            self.isLoading.value = false
            if let error = error {
                self.updateStatus(error)
                return
            }
            
            self.status = nil
            self.processCountries(countries!)
        }
    }
    
    func filterCountries(keyword: String) {
        if keyword == "" {
            filteredCountryCellViewModels = countryCellViewModels
        } else {
            filteredCountryCellViewModels = countryCellViewModels.filter({ return $0.name.lowercased().range(of: keyword) != nil || $0.region.lowercased().range(of: keyword) != nil })
        }
        
        self.keyword = keyword
        print("filterResults: \(filteredCountryCellViewModels.count)")
    }
    func getCountriesCount() -> Int {
        return filteredCountryCellViewModels.count//countryCellViewModels.count
    }
    
    func getCountryCellViewModel(at indexPath: IndexPath) -> CountryCellViewModel {
        return filteredCountryCellViewModels[indexPath.row]//countryCellViewModels[indexPath.row]
    }
    
    func userSelectedCountry(at indexPath: IndexPath) {
        guard status == nil && countryCellViewModels.count > 0 else {
            fetchCountries()
            return
        }
        
        let index: Int = filteredCountryCellViewModels[indexPath.row].index
        showCountryDetailClosure?(CountryDetailViewModel(with: countries[index]))
        print("userSelectedCountry: \(index)")
    }
}

//MARK:- private func
extension CountriesViewModel {
    private func processCountries(_ countries: [Country]){
        self.countries = countries
        countryCellViewModels = countries.map({ (country) -> CountryCellViewModel in
            return CountryCellViewModel(with: country)
        })
        var index = 0
        for cellViewModel in countryCellViewModels {
            cellViewModel.index = index
            index += 1
        }
        filterCountries(keyword: keyword)
    }
    private func updateStatus(_ status: String) {
        self.status = status.localized()
        reloadCountriesTableViewClosure?()
    }
    
}
