//
//  ViewController.swift
//  SwiftDecodableJSON
//
//  Created by Simran Singh Sandhu on 27/02/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Can create your own API Key from "calendarific.com"
    var apiKey = "533b84a223a70aa1599d38660e5103628c842b3d"
    var countryCode = "IN"
    var holidayYear = "2020"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHolidayData()
        
    }

    private func getHolidayData() {
        
        // this is will JSON data.
        let modifiedURL = " https://calendarific.com/api/v2/holidays?&api_key=\(apiKey)&country=\(countryCode)&year=\(holidayYear)"
        
        
        
    }

}

