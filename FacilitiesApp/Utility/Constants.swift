//
//  Constants.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import UIKit

struct Constants {
    
    static let selectTitle = "Select"
    static let cancelTitle = "Cancel"
    static let confirmTitle = "Confirm"
    static let facilitiesTitle = "Facilities"
    static let unavailableTitle = "Unavailable"
    static let noDataTitle = "Data Unavailable"
    static let noDataSubtitle = "Sorry, no facilities are available at the moment. You can check again in some time"
    static let noInternetTitle = "No Internet"
    static let noInternetSubtitle = "Your internet connection appears to be offline. Please check and try again"
    static let unknownTitle = "Uh Oh!"
    static let unknownSubtitle = "There seems to be an issue fetching available facilities from the server"
    static let refreshTitle = "Refresh"
    static let baseApiURL = URL(string: "https://my-json-server.typicode.com/")
    static let commonApiHeaders = ["Content-Type": "application/json"]
    static let noInternetErrorCode: Int = 6
    static let primaryColor = UIColor(red: 35 / 255, green: 166 / 255, blue: 247 / 255, alpha: 1)
    
}
