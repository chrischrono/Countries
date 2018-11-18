//
//  CountryCellViewModel.swift
//  Countries
//
//  Created by Christian  Huang on 17/11/18.
//  Copyright © 2018 Christian Huang. All rights reserved.
//

import UIKit

class CountryCellViewModel: NSObject {
    var index: Int!
    var thumbFlag: String
    var name: String
    var region: String
    
    init(with country: Country){
        thumbFlag = "https://raw.githubusercontent.com/hjnilsson/country-flags/master/png100px/\(country.alpha2Code.lowercased()).png"
        name = country.name
        region = country.subregion
    }
}
