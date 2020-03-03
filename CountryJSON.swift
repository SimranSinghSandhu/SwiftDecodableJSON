//
//  countryJSON.swift
//  SwiftDecodableJSON
//
//  Created by Simran Singh Sandhu on 03/03/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import Foundation

extension ViewController {

    // Getting Country Name and Code from Locally Stored JSON.
    func getCountryData() {
        let path = Bundle.main.path(forResource: "CountryCode", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {return}
            
            do {
                let countryData = try JSONDecoder().decode([Country].self, from: data)
                self.countryArray = countryData
                self.sortedCountryArray = self.countryArray
                
            } catch {
                print("Unable to Fetch Country Data = ", error)
            }
            
        }.resume()
    }
}
