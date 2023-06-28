//
//  ResponseModel.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import Foundation

struct ResponseModel: Codable {
    let facilities: [FacilityDetail]
    let exclusions: [[Exclusion]]
}

struct FacilityDetail: Codable {
    let id: String
    let name: String
    let options: [FacilityOption]
    
    private enum CodingKeys: String, CodingKey {
        case id = "facility_id"
        case name
        case options
    }
    
}

struct FacilityOption: Codable,
                       Equatable {
    let id: String
    let name: String
    let icon: String
}

struct Exclusion: Codable {
    let facilityId: String
    let optionId: String
    
    private enum CodingKeys: String, CodingKey {
        case facilityId = "facility_id"
        case optionId = "options_id"
    }
    
}
