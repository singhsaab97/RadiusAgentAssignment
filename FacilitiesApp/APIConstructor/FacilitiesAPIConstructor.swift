//
//  FacilitiesAPIConstructor.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import Foundation
import Moya

enum FacilitiesAPIConstructor {
    case facilitiesList
}

// MARK: - TargetType Conformation
extension FacilitiesAPIConstructor: TargetType {
    
    var baseURL: URL {
        switch self {
        case .facilitiesList:
            return Constants.baseApiURL!
        }
    }
    
    var path: String {
        switch self {
        case .facilitiesList:
            return "iranjith4/ad-assignment/db"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .facilitiesList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .facilitiesList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return Constants.commonApiHeaders
    }
    
}
