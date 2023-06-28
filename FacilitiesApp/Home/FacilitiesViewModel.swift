//
//  FacilitiesViewModel.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import Foundation

protocol FacilitiesViewModelPresenter: AnyObject {
    func setNavigationTitle(_ title: String)
    func startLoading()
    func stopLoading()
}

protocol FacilitiesViewModelable {
    var bookButtonTitle: String { get }
    var presenter: FacilitiesViewModelPresenter? { get set }
    func screenDidLoad()
}

final class FacilitiesViewModel: FacilitiesViewModelable {
    
    weak var presenter: FacilitiesViewModelPresenter?
    
    private let dataHandler: FacilitiesDataHandler
    
    init() {
        dataHandler = FacilitiesDataHandler()
    }
    
}

// MARK: - Exposed Helpers
extension FacilitiesViewModel {
    
    var bookButtonTitle: String {
        return Constants.bookButtonTitle
    }
    
    func screenDidLoad() {
        // Fetch response model
        dataHandler.fetchData { [weak self] state in
            switch state {
            case .loading:
                self?.presenter?.startLoading()
            case let .response(model):
                print("Model \(model)")
                self?.presenter?.stopLoading()
            case let .error(message):
                self?.presenter?.stopLoading()
            }
        }
        // Set navigation title
        presenter?.setNavigationTitle(Constants.facilitiesTitle)
    }
    
}
