//
//  CountriesViewController.swift
//  DTT
//
//  Created by Martin Herholdt Rasmussen on 15/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class CountriesViewController: UIViewController {
 
    @IBOutlet private weak var tableView: UITableView!
    private var countries = [Country]()
    private var favoriteCountryCodes: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var listenerRegistration: ListenerRegistration? {
        willSet {
            listenerRegistration?.remove()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        Database.getCountryList { countries in
            self.countries = countries
            self.tableView.reloadData()
        }
        
        listenerRegistration = Database.listenToUser(facebookID: Database.myID, completion: { [weak self] (user) in
            self?.favoriteCountryCodes = user.countryCodes
        })
    }

    deinit {
        listenerRegistration = nil
    }
}

extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.cellIdentifier) as! CountryTableViewCell
        let country = countries[indexPath.row]
        cell.country = country
        cell.contentView.backgroundColor = favoriteCountryCodes.contains(country.code) ? UIColor.green.withAlphaComponent(0.2) : UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
}

extension CountriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryCode = countries[indexPath.row].code
        Database.toggleCountryCode(facebookID: Database.myID, countryCode: countryCode)
    }
}
