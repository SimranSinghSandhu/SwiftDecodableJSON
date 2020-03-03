//
//  SearchBarNavigationController.swift
//  SwiftDecodableJSON
//
//  Created by Simran Singh Sandhu on 03/03/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UISearchBarDelegate {
    
    func settingNavigationItems() {

        // Updating Navigation Titile
        navigationItem.title = countryName
        
        // Setting Search Bar inside Navigation Controller
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController?.searchBar.placeholder = "Enter Country Name"
        
    }
    
    // Calls When Search Bar is Begin Editing.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        animatingErrorLabel(value: -1000)
        sortedCountryArray = countryArray
        tableViewCountry.reloadData()
        tableViewCountry.scrollToRow(at: [0,0], at: .top, animated: true)
        showCountryTableView(frame: screenSize)
    }
    
    // Calls When Cancel Button is Pressed on Search Bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideCountryTableView(frame: screenSize)
    }
    
    // Calls When Texts Changes in Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        sortedCountryArray = countryArray
        
        if searchText != "" {
            sortedCountryArray = countryArray.filter({$0.name.contains(searchText)})
        }
        
        tableViewCountry.reloadData()
    }
    
    
    
    // Show Country TableView when SearchBar Editing Begins
    func showCountryTableView(frame: CGRect) {
        UIView.animate(withDuration: 0.2) {
            self.tableViewCountry.frame = CGRect(x: 0, y: self.tableViewHoliday.frame.origin.y, width: frame.width, height: frame.height - self.keyboardHeight)
        }
    }
    
    // Hide Country TableView when Country is Selected
    func hideCountryTableView(frame: CGRect) {
        UIView.animate(withDuration: 0.2) {
            self.tableViewCountry.frame = CGRect(x: 0, y: self.tableViewHoliday.frame.origin.y, width: frame.width, height: 0)
        }
    }
}
