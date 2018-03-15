//
//  FriendCountryMatchListViewController.swift
//  DTT
//
//  Created by Troels Michael Trebbien on 15/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FriendCountryMatchListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var countries = [Country]()
    private var presentedCountries = [[Country]]()
    var friend: FBUser!
    private var myFavoriteCountryCodes: [String] = [] {
        didSet {
            sortCountriesAndReload()
        }
    }
    private var theirFavoriteCountryCodes: [String] = [] {
        didSet {
            sortCountriesAndReload()
        }
    }
    private var listenerRegistrations = [ListenerRegistration]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        Database.getCountryList { countries in
            self.countries = countries
            self.sortCountriesAndReload()
        }
        
        let reg1 = Database.listenToUser(facebookID: Database.myID, completion: { [weak self] (user) in
            self?.myFavoriteCountryCodes = user.countryCodes
        })
        let reg2 = Database.listenToUser(facebookID: friend.id, completion: { [weak self] (user) in
            self?.theirFavoriteCountryCodes = user.countryCodes
        })
        listenerRegistrations.append(contentsOf: [reg1, reg2])
    }
    
    private func sortCountriesAndReload() {
        let mutualCountries = countries.filter { (country) -> Bool in
            return myFavoriteCountryCodes.contains(country.code) && theirFavoriteCountryCodes.contains(country.code)
        }
        let myCountries = countries.filter { (country) -> Bool in
            return myFavoriteCountryCodes.contains(country.code) && !theirFavoriteCountryCodes.contains(country.code)
        }
        let theirCountries = countries.filter { (country) -> Bool in
            return !myFavoriteCountryCodes.contains(country.code) && theirFavoriteCountryCodes.contains(country.code)
        }
        presentedCountries = [mutualCountries, myCountries, theirCountries]
        tableView.reloadData()
    }
    
    deinit {
        listenerRegistrations.forEach { (registration) in
            registration.remove()
        }
    }
}

extension FriendCountryMatchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.cellIdentifier) as! CountryTableViewCell
        let country = presentedCountries[indexPath.section][indexPath.row]
        cell.country = country
        switch indexPath.section {
        case 0:
            cell.contentView.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        case 1:
            cell.contentView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        default:
            cell.contentView.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentedCountries[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Countries we both want to visit"
        case 1:
            return "Countries only I want to visit"
        default:
            return "Countries only \(friend.name.split(separator: " ").first ?? "(s)he") wants to visit"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presentedCountries.count
    }
}

