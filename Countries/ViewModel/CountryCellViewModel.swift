//
//  CountryCellViewModel.swift
//  Countries
//
//  Created by Christian  Huang on 17/11/18.
//  Copyright © 2018 Christian Huang. All rights reserved.
//

import UIKit

class CountryCellViewModel: NSObject {
    var thumbFlag: String
    var name: String
    var region: String
    
    init(with country: Country){
        thumbFlag = country.alpha2Code
        name = country.name
        region = country.subregion
    }
}
