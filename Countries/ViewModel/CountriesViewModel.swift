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
    private var countryCellViewModels: [CountryCellViewModel] = [] {
        didSet {
            reloadCountriesTableViewClosure?()
        }
    }
    
    /** hold the network manager for RESTCountries's API */
    var networkManager: CountriesNetworkManager = NetworkManager(environment: .production)
    
    var isLoading: Dynamic<Bool> = Dynamic(false)
    var status: String?
    
    /** closure to reload CountriesTableView */
    var reloadCountriesTableViewClosure: (()->())?
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
    
    
    func getCountriesCount() -> Int {
        return countryCellViewModels.count
    }
    
    func getCountryCellViewModel(at indexPath: IndexPath) -> CountryCellViewModel {
        return countryCellViewModels[indexPath.row]
    }
    
    func userSelectedCountry(at indexPath: IndexPath) {
        guard status == nil else {
            fetchCountries()
            return
        }
        
        print("userSelectedCountry: \(indexPath.row)")
    }
}

//MARK:- private func
extension CountriesViewModel {
    private func processCountries(_ countries: [Country]){
        self.countries = countries
        self.countryCellViewModels = countries.map({ (country) -> CountryCellViewModel in
            return CountryCellViewModel(with: country)
        })
    }
    private func updateStatus(_ status: String) {
        self.status = status.localized()
        reloadCountriesTableViewClosure?()
    }
    
}
