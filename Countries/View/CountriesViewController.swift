//
//  CountriesViewController.swift
//  Countries
//
//  Created by Christian  Huang on 15/11/18.
//  Copyright © 2018 Christian Huang. All rights reserved.
//

import UIKit

class CountriesViewController: UIViewController {
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var countriesTableView: UITableView!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    
    var countriesViewModel = CountriesViewModel()
    private var scrollOffset = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        countriesViewModel.fetchCountries()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CountryDetailViewController, let viewModel = sender as? CountryDetailViewModel {
            destination.countryDetailViewModel = viewModel
        }
    }
    
    @IBAction func searchFieldEditingChanged(_ sender: Any) {
        countriesViewModel.filterCountries(keyword: (searchField.text ?? "").lowercased())
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
        countriesViewModel.showCountryDetailClosure = { viewModel in
            self.performSegue(withIdentifier: "countryDetailSegue", sender: viewModel)
        }
    }
}

//MARK:- UITableViewDelegate
extension CountriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countriesViewModel.userSelectedCountry(at: indexPath)
    }
}

//MARK:- UITableViewDataSource
extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, countriesViewModel.getCountriesCount())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if countriesViewModel.getCountriesCount() == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusCellIdentifier", for: indexPath)
            if let status = countriesViewModel.status {
                cell.textLabel?.text = status
            } else {
                cell.textLabel?.text = "filter_no_result".localized()
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCellIdentifier", for: indexPath) as! CountryCell
        cell.configureCell(with: countriesViewModel.getCountryCellViewModel(at: indexPath))
        
        return cell
    }
}

//MARK:- UIScrollViewDelegate
extension CountriesViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        
        if offset.y > scrollOffset.y + 10 {
            searchField.resignFirstResponder()
        }
        
        scrollOffset = offset
    }
}

//MARK:- UITextFieldDelegate
extension CountriesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

