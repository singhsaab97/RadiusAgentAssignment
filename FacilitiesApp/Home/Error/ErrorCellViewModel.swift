//
//  ErrorCellViewModel.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 29/06/23.
//

import UIKit

protocol ErrorCellViewModelListener: AnyObject {
    func refreshButtonTapped()
}

protocol ErrorCellViewModelable {
    var state: ErrorCellViewModel.State { get }
    var refreshButtonTitle: String { get }
    func refreshButtonTapped()
}

final class ErrorCellViewModel: ErrorCellViewModelable {
    
    enum State: String {
        case noData
        case noInternet
        case unknown
    }
    
    let state: State
    
    private weak var listener: ErrorCellViewModelListener?
    
    init(state: State, listener: ErrorCellViewModelListener?) {
        self.state = state
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension ErrorCellViewModel {
    
    var refreshButtonTitle: String {
        return Constants.refreshTitle
    }
    
    func refreshButtonTapped() {
        listener?.refreshButtonTapped()
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
