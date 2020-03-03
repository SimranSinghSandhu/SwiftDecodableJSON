//
//  holidayJSON.swift
//  SwiftDecodableJSON
//
//  Created by Simran Singh Sandhu on 03/03/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import Foundation
import SVProgressHUD

extension ViewController {

    func getHolidayData() {

        SVProgressHUD.show()
        
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
                    SVProgressHUD.dismiss()
                    self.tableViewHoliday.reloadData()
                    self.tableViewHoliday.scrollToRow(at: [0,0], at: .top, animated: false)
                }
                
            } catch {
//                print("Unable to Fetch Data = ", error)
                self.holidayArray.removeAll()
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                self.tableViewHoliday.reloadData()
                self.errorLabel.text = "Holidays of this Country is Currently Unavailable.\n\nTry Switching to some other Country."
                self.animatingErrorLabel(value: 10)
                }
            }
            
        }.resume()
    }
}
