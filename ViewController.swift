//
//  ViewController.swift
//  SwiftDecodableJSON
//
//  Created by Simran Singh Sandhu on 27/02/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var screenSize = UIScreen.main.bounds
    var keyboardHeight = CGFloat()
    
    // Unique Key of Cell for TableViewHoliday
    let holidayCellId = "holidayCellId"
    let countryCellId = "countryCellId"
    
    @IBOutlet weak var tableViewHoliday: UITableView!
    
    lazy var tableViewCountry: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // Can create your own API Key from "calendarific.com"
    var apiKey = "533b84a223a70aa1599d38660e5103628c842b3d"
    var countryCode = "IN"
    var holidayYear = "2020"
    
    // Array of all the Holidays.
    var holidayArray = [Holidays]()
    var countryArray = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableViewCountry)
        
        getKeyboardHeight()
        
        settingDelegates()
        settingNavigationItems()
        getCountryData()
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
                    self.tableViewHoliday.scrollToRow(at: [0,0], at: .top, animated: false)
                }
                
            } catch {
                print("Unable to Fetch Data = ", error)
            }
            
        }.resume()
    }
    
}

// TableView Delegate and Datasource Functions.
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func settingDelegates() {
          tableViewHoliday.delegate = self
          tableViewHoliday.dataSource = self
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == tableViewHoliday ? holidayArray.count : countryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewHoliday {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: holidayCellId)
            cell.textLabel?.text = holidayArray[indexPath.row].name
            cell.detailTextLabel?.text = holidayArray[indexPath.row].date.iso
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: countryCellId)
            cell.textLabel?.text = countryArray[indexPath.row].name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == tableViewCountry {
            let selectedCountry = countryArray[indexPath.row]
            countryCode = selectedCountry.code
            navigationItem.title = selectedCountry.name
            hideCountryTableView(frame: screenSize)
            navigationItem.searchController?.searchBar.resignFirstResponder()

            getHolidayData()
        }
    }

}

extension ViewController: UISearchBarDelegate {
    
    private func settingNavigationItems() {
        // Setting Navigation Large Titles
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Setting Search Bar inside Navigation Controller
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showCountryTableView(frame: screenSize)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideCountryTableView(frame: screenSize)
    }
}

extension ViewController {
    private func showCountryTableView(frame: CGRect) {
        UIView.animate(withDuration: 0.2) {
            self.tableViewCountry.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - self.keyboardHeight)
        }
    }
    
    private func hideCountryTableView(frame: CGRect) {
        UIView.animate(withDuration: 0.2) {
            self.tableViewCountry.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
        }
    }
}

extension ViewController {
    private func getKeyboardHeight() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
}


// Getting Country Name and Code from Locally Stored JSON.

extension ViewController {
    private func getCountryData() {
        let path = Bundle.main.path(forResource: "CountryCode", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {return}
            
            do {
                let countryData = try JSONDecoder().decode([Country].self, from: data)
                self.countryArray = countryData
                
            } catch {
                print("Unable to Fetch Country Data = ", error)
            }
            
        }.resume()
    
    }
}

