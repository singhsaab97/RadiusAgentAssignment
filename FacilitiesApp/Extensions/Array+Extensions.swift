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
