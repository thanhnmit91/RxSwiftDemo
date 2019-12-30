//
//  CountryModel.swift
//  RxSwiftProj
//
//  Created by administrator on 12/20/19.
//  Copyright © 2019 Vision. All rights reserved.
//

import UIKit

struct countryModel: Codable {
    let code: Int?
    let result: [countryListModel]?
    
    private enum CodingKeys: String, CodingKey {
        case code
        case result
    }
}
struct countryListModel: Codable {
    let code: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case code
        case name
    }
}
