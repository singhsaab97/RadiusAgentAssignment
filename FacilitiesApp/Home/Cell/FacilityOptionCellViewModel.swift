//
//  FacilityOptionCellViewModel.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import Foundation

protocol FacilityOptionCellViewModelable {
    var option: FacilityOption { get }
}

final class FacilityOptionCellViewModel: FacilityOptionCellViewModelable {
    
    let option: FacilityOption
    
    init(option: FacilityOption) {
        self.option = option
    }
    
}
