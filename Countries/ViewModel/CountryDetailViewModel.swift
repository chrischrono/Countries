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
    var flag: Dynamic<String> = Dynamic("")
    var name: Dynamic<String> = Dynamic("")
    var alphaCode: Dynamic<[String]> = Dynamic([])
    var capital: Dynamic<String> = Dynamic("")
    var region: Dynamic<String> = Dynamic("")
    var subregion: Dynamic<String> = Dynamic("")
    var population: Dynamic<Int> = Dynamic(0)
    var coordinate: Dynamic<CLLocationCoordinate2D> = Dynamic(CLLocationCoordinate2D(latitude: 0, longitude: 0))
    var demonym: Dynamic<String> = Dynamic("")
    var area: Dynamic<Double?> = Dynamic(0)
    var gini: Dynamic<Float?> = Dynamic(0)
    var nativeName: Dynamic<String> = Dynamic("")
    var currencies: Dynamic<[String]> = Dynamic([])
    var languages: Dynamic<[String]> = Dynamic([])
    
    
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
