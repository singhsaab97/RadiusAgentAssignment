//
//  FacilityOptionCellViewModel.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import Foundation

protocol FacilityOptionCellViewModelable {
    var option: FacilityOption { get }
    var state: FacilityOptionCellViewModel.State { get }
}

final class FacilityOptionCellViewModel: FacilityOptionCellViewModelable {
    
    enum State {
        case selected
        case deselected
        case disabled
    }
    
    let option: FacilityOption
    let state: State
    
    init(option: FacilityOption, state: State) {
        self.option = option
        self.state = state
    }
    
}

// MARK: - FacilityOptionCellViewModel.State Helpers
extension FacilityOptionCellViewModel.State {
    
    var isSelectionViewHidden: Bool {
        switch self {
        case .selected, .deselected:
            return false
        case .disabled:
            return true
        }
    }
    
    var isUnavailableLabelHidden: Bool {
        switch self {
        case .selected, .deselected:
            return true
        case .disabled:
            return false
        }
    }
    
    var unavailableText: String? {
        switch self {
        case .selected, .deselected:
            return nil
        case .disabled:
            return Constants.unavailableTitle
        }
    }
    
    var isUserInteractionEnabled: Bool {
        switch self {
        case .selected, .deselected:
            return true
        case .disabled:
            return false
        }
    }
    
}
