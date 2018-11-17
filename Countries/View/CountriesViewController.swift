//
//  CountriesViewController.swift
//  Countries
//
//  Created by Christian  Huang on 15/11/18.
//  Copyright © 2018 Christian Huang. All rights reserved.
//

import UIKit

class CountriesViewController: UIViewController {
    @IBOutlet private weak var countriesTableView: UITableView!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    
    var countriesViewModel = CountriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        countriesViewModel.fetchCountries()
    }

}

//MARK:- ViewModel related
extension CountriesViewController {
    private func initViewModel() {
        countriesViewModel.reloadCountriesTableViewClosure = {
            DispatchQueue.main.async {
                self.countriesTableView.reloadData()
            }
        }
        countriesViewModel.isLoading.listener = { isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self.loadingView.startAnimating()
                } else {
                    self.loadingView.stopAnimating()
                }
                
            }
        }
    }
}

extension CountriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countriesViewModel.userSelectedCountry(at: indexPath)
    }
}

extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, countriesViewModel.getCountriesCount())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let status = countriesViewModel.status {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusCellIdentifier", for: indexPath)
            cell.textLabel?.text = status
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCellIdentifier", for: indexPath) as! CountryCell
        cell.configureCell(with: countriesViewModel.getCountryCellViewModel(at: indexPath))
        
        return cell
    }
}

