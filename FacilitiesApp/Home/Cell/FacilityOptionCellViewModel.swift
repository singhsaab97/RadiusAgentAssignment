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
    
    /// Determines the state of the option cell
    /// - `idle`: When cell is interactive but selection isn't allowed
    /// - `selected`: When cell is interactive and selected
    /// - `deselected`: When cell is interactive and deselected
    /// - `disabled`: When cell is non-interactive and greyed out
    enum State {
        case idle
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
        case .idle, .disabled:
            return true
        }
    }
    
    var isUnavailableLabelHidden: Bool {
        switch self {
        case .idle, .selected, .deselected:
            return true
        case .disabled:
            return false
        }
    }
    
    var unavailableText: String? {
        switch self {
        case .idle, .selected, .deselected:
            return nil
        case .disabled:
            return Constants.unavailableTitle
        }
    }
    
    var isUserInteractionEnabled: Bool {
        switch self {
        case .idle, .selected, .deselected:
            return true
        case .disabled:
            return false
        }
    }
    
}
