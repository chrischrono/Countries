//
//  CountryDetailViewController.swift
//  Countries
//
//  Created by Christian  Huang on 17/11/18.
//  Copyright © 2018 Christian Huang. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class CountryDetailViewController: UIViewController {
    
    @IBOutlet private weak var mainStackView: UIStackView!
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var geographyStackView: UIStackView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var extraStackView: UIStackView!
    private var infoViews = [String: InfoView]()
    var countryDetailViewModel: CountryDetailViewModel!
    
    enum CountryDetailInfo: String {
        case name = "Name"
        case alphaCode = "Alpha Code"
        case capital = "Capital"
        case region = "Region"
        case subregion = "Subregion"
        case population = "Population"
        case demonym = "Demonym"
        case area = "Area"
        case currencies = "Currencies"
        case languages = "Languages"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initViews()
        initViewModel()
    }

}

//MARK:- ViewModel related
extension CountryDetailViewController {
    private func initViewModel() {
        countryDetailViewModel.flag.bindAndFire { flag in
            self.flagImageView.kf.setImage(with: URL(string: flag))
        }
        countryDetailViewModel.name.bindAndFire {  self.setInfoView(.name, info: $0) }
        countryDetailViewModel.capital.bindAndFire {  self.setInfoView(.capital, info: $0) }
        countryDetailViewModel.alphaCode.bindAndFire {  self.setInfoView(.alphaCode, info: $0.joined(separator: " - ")) }
        countryDetailViewModel.region.bindAndFire {  self.setInfoView(.region, info: $0) }
        countryDetailViewModel.subregion.bindAndFire {  self.setInfoView(.subregion, info: $0) }
        
        countryDetailViewModel.coordinate.bindAndFire { coordinate in
            var regionRadius: CLLocationDistance = 100000
            if let area = self.countryDetailViewModel.area.value {
                regionRadius = area.squareRoot() * 1200
            }
            let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            self.mapView.setRegion(coordinateRegion, animated: true)
        }
        countryDetailViewModel.area.bindAndFire {  self.setInfoView(.area, info: $0 == nil ? "-" : "\($0 ?? 0) km2") }
        countryDetailViewModel.population.bindAndFire {  self.setInfoView(.population, info: "\($0)") }
        countryDetailViewModel.demonym.bindAndFire {  self.setInfoView(.demonym, info: $0) }
        
        countryDetailViewModel.languages.bindAndFire {  self.setInfoView(.languages, info: $0.joined(separator: ", ")) }
        countryDetailViewModel.currencies.bindAndFire {  self.setInfoView(.currencies, info: $0.joined(separator: "\n")) }
    }
}

//MARK:- private func
extension CountryDetailViewController {
    private func initViews() {
        flagImageView.layer.borderWidth = 2
        flagImageView.layer.borderColor = UIColor.darkGray.cgColor
        
        let mainInfo: [CountryDetailInfo] = [.name, .capital, .alphaCode, .region, .subregion]
        for detailInfo in mainInfo.reversed() {
            let infoView = createInfoView(detailInfo)
            mainStackView.insertArrangedSubview(infoView, at: 1)
        }
        let geographyInfo: [CountryDetailInfo] = [.area, .population, .demonym]
        for detailInfo in geographyInfo.reversed() {
            let infoView = createInfoView(detailInfo)
            geographyStackView.insertArrangedSubview(infoView, at: 2)
        }
        let extraInfo: [CountryDetailInfo] = [.languages, .currencies]
        for detailInfo in extraInfo.reversed() {
            let infoView = createInfoView(detailInfo)
            extraStackView.insertArrangedSubview(infoView, at: 1)
        }
    }
    
    private func createInfoView(_ detailInfo: CountryDetailInfo) -> InfoView {
        let infoView = InfoView.instanceFromNib(title: detailInfo.rawValue)
        infoViews[detailInfo.rawValue] = infoView
        return infoView
    }
    
    private func setInfoView(_ detailInfo: CountryDetailInfo, info: String) {
        if let infoView = infoViews[detailInfo.rawValue] {
            infoView.info = info
        }
    }
}
