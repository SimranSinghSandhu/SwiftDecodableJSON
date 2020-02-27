//
//  ViewController.swift
//  SwiftDecodableJSON
//
//  Created by Simran Singh Sandhu on 27/02/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Unique Key of Cell for TableViewHoliday
    let holidayCellId = "holidayCellId"
    
    @IBOutlet weak var tableViewHoliday: UITableView!
    
    // Can create your own API Key from "calendarific.com"
    var apiKey = "533b84a223a70aa1599d38660e5103628c842b3d"
    var countryCode = "IN"
    var holidayYear = "2020"
    
    // Array of all the Holidays.
    var holidayArray = [Holidays]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingDelegates()
        settingNavigationItems()
        getHolidayData()
        
    }

    private func getHolidayData() {
        
        // this is will JSON data.
        let modifiedURL = "https://calendarific.com/api/v2/holidays?&api_key=\(apiKey)&country=\(countryCode)&year=\(holidayYear)"
        
        let url = URL(string: modifiedURL)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard let data = data else {return}
            
            do {
                // JSONDecoder can Throw Error
                let holidayData = try JSONDecoder().decode(Root.self, from: data)
                
                // Inserting the Holiday Data fetched from web into the array of Holidays which we will use to show the data in TableViewCells
                self.holidayArray = holidayData.responses.holidays
                
                DispatchQueue.main.async {
                    self.tableViewHoliday.reloadData()
                }
                
            } catch {
                print("Unable to Fetch Data = ", error)
            }
            
        }.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func settingDelegates() {
          tableViewHoliday.delegate = self
          tableViewHoliday.dataSource = self
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holidayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: holidayCellId)
        cell.textLabel?.text = holidayArray[indexPath.row].name
        cell.detailTextLabel?.text = holidayArray[indexPath.row].date.iso
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ViewController: UISearchBarDelegate {
    
    private func settingNavigationItems() {
        // Setting Search Bar inside Navigation Controller
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
    }
}
