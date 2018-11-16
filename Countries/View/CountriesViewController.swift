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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

