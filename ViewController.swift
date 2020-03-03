//
//  ViewController.swift
//  SwiftDecodableJSON
//
//  Created by Simran Singh Sandhu on 27/02/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    var screenSize = UIScreen.main.bounds
    var keyboardHeight = CGFloat()
    
    // Unique Key of Cell for TableViewHoliday
    let holidayCellId = "holidayCellId"
    let countryCellId = "countryCellId"
    
    @IBOutlet weak var tableViewHoliday: UITableView!
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tableViewCountry: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // Can create your own API Key from "calendarific.com"
    var apiKey = "533b84a223a70aa1599d38660e5103628c842b3d"
    var countryName = "India"
    var countryCode = "IN"
    var holidayYear = "2020"
    
    // Array of all the Holidays.
    var holidayArray = [Holidays]()
    var countryArray = [Country]()
    var sortedCountryArray = [Country]()
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var descriptionViewHeightConstraint: NSLayoutConstraint!
    
    var errorLabelLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCode = UserDefaults.standard.string(forKey: "code") ?? "IN"
        countryName = UserDefaults.standard.string(forKey: "name") ?? "India"
        view.addSubview(tableViewCountry)
        view.addSubview(errorLabel)
        settingConstraints()
        getKeyboardHeight()
        settingGestureRecognizer()
        settingDelegates()
        settingNavigationItems()
        updateDescriptionViewConstraints(height: 0, animation: false)
        getCountryData()
        getHolidayData()
    }

}

// TableView Delegate and Datasource Functions.
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func settingDelegates() {
          tableViewHoliday.delegate = self
          tableViewHoliday.dataSource = self
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == tableViewHoliday ? holidayArray.count : sortedCountryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewHoliday {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: holidayCellId)
            cell.textLabel?.text = holidayArray[indexPath.row].name
            cell.detailTextLabel?.text = holidayArray[indexPath.row].date.iso
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: countryCellId)
            cell.textLabel?.text = sortedCountryArray[indexPath.row].name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == tableViewCountry {
            let selectedCountry = sortedCountryArray[indexPath.row]
            countryCode = selectedCountry.code
            countryName = selectedCountry.name
            // Setting Navigation Title as Country Selected
            navigationItem.title = selectedCountry.name
            // Hide Country TableView
            hideCountryTableView(frame: screenSize)
            navigationItem.searchController?.searchBar.resignFirstResponder()
            getHolidayData()
            // Hiding Search Controller
            navigationItem.searchController?.isActive = false
            UserDefaults.standard.set(countryCode, forKey: "code")
            UserDefaults.standard.set(countryName, forKey: "name")
        }
        else {
            updateDescription(description: holidayArray[indexPath.row].description)
        }
    }

}

// Get Keyboard Height
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

// Setting and Animating Error Label (UILabel)
extension ViewController {
    
    // Calls in ViewDidLoad
    private func settingConstraints() {
        errorLabelLeadingConstraint = errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -1000)
        errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        errorLabelLeadingConstraint.isActive = true
    }
    
    // Calls When Error Catches or SearchBar Editing Begins.
    func animatingErrorLabel(value: CGFloat) {
        errorLabelLeadingConstraint.constant = value
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}



