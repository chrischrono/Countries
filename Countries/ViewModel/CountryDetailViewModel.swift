//
//  CountryDetailViewModel.swift
//  Countries
//
//  Created by Christian  Huang on 18/11/18.
//  Copyright © 2018 Christian Huang. All rights reserved.
//

import UIKit
import MapKit

class CountryDetailViewModel: NSObject {
    private var country: Country!
    let flag: Dynamic<String> = Dynamic("")
    let name: Dynamic<String> = Dynamic("")
    let alphaCode: Dynamic<[String]> = Dynamic([])
    let capital: Dynamic<String> = Dynamic("")
    let region: Dynamic<String> = Dynamic("")
    let subregion: Dynamic<String> = Dynamic("")
    let population: Dynamic<Int> = Dynamic(0)
    let coordinate: Dynamic<CLLocationCoordinate2D> = Dynamic(CLLocationCoordinate2D(latitude: 0, longitude: 0))
    let demonym: Dynamic<String> = Dynamic("")
    let area: Dynamic<Double?> = Dynamic(0)
    let gini: Dynamic<Float?> = Dynamic(0)
    let nativeName: Dynamic<String> = Dynamic("")
    let currencies: Dynamic<[String]> = Dynamic([])
    let languages: Dynamic<[String]> = Dynamic([])
    
    
    init(with country: Country){
        super.init()
        self.setCountryData(country)
    }
}

extension CountryDetailViewModel {
    func setCountryData(_ country: Country){
        self.country = country
        
        flag.value = "https://raw.githubusercontent.com/hjnilsson/country-flags/master/png250px/\(country.alpha2Code.lowercased()).png"
        name.value = country.name
        alphaCode.value = [country.alpha2Code, country.alpha3Code]
        capital.value = country.capital
        region.value = country.region
        subregion.value = country.subregion
        population.value = country.population
        demonym.value = country.demonym
        area.value = country.area
        coordinate.value = CLLocationCoordinate2D(latitude: country.latlng[0] , longitude: country.latlng[1])
        gini.value = country.gini
        nativeName.value = country.nativeName
        var currencyStrings = [String]()
        for currency in country.currencies {
            if let string = currency.toString() {
                currencyStrings.append(string)
            }
        }
        currencies.value = currencyStrings
        languages.value = country.languages.map({ return $0.name })
    }
}
