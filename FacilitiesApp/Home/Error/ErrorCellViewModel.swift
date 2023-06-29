//
//  ErrorCellViewModel.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 29/06/23.
//

import UIKit

protocol ErrorCellViewModelable {
    var state: ErrorCellViewModel.State { get }
}

final class ErrorCellViewModel: ErrorCellViewModelable {
    
    enum State: String {
        case noData
        case noInternet
        case unknown
    }
    
    let state: State
    
    init(state: State) {
        self.state = state
    }
    
}

// MARK: - ErrorCellViewModel.State Helpers
extension ErrorCellViewModel.State {
    
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
    
    var title: String {
        switch self {
        case .noData:
            return Constants.noDataTitle
        case .noInternet:
            return Constants.noInternetTitle
        case .unknown:
            return Constants.unknownTitle
        }
    }
    
    var subtitle: String {
        switch self {
        case .noData:
            return Constants.noDataSubtitle
        case .noInternet:
            return Constants.noInternetSubtitle
        case .unknown:
            return Constants.unknownSubtitle
        }
    }
    
}
