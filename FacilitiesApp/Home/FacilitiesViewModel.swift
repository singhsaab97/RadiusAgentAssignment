//
//  FacilitiesViewModel.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import Foundation

protocol FacilitiesViewModelable {
    
}

final class FacilitiesViewModel: FacilitiesViewModelable {
    
    private let dataHandler: FacilitiesDataHandler
    
    init() {
        dataHandler = FacilitiesDataHandler()
    }
    
}
