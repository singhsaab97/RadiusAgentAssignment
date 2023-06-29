//
//  Array+Extensions.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import Foundation

extension Array {
    
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}

extension Array where Element == String {
    
    var joined: String {
        switch count {
        case 0:
            return String()
        case 1:
            return first!
        case 2:
            return joined(separator: " \(Constants.andSeparator) ")
        default:
            let commaSeparated = dropLast().joined(separator: "\(Constants.commaSeparator) ")
            return "\(commaSeparated) \(Constants.andSeparator) \(last!)"
        }
    }
    
}
