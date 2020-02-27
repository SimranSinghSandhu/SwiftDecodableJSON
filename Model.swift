//
//  Model.swift
//  SwiftDecodableJSON
//
//  Created by Simran Singh Sandhu on 27/02/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import Foundation

struct Root: Decodable {
    var responses: Responses
    
    // If the Var name if diffrent from JSON Key, then we use Enums so Swift will know which JSON key we are looking for
    private enum CodingKeys: String, CodingKey {
        case responses = "respose"
    }
}

struct Responses: Decodable {
    
    var holidays: [Holidays]
    
    // If var name is same as JSON Key, dont have to write the Enums or can leave them empty as did with the next Struct
    private enum CodingKeys: String, CodingKey {
        case holidays
    }
}

struct Holidays: Decodable {
    var name: String
    var date: Date
}

struct Date: Decodable {
    var iso: String
}
