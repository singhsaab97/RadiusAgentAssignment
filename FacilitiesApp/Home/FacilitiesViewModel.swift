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
    func reload()
}

protocol FacilitiesViewModelable {
    var numberOfSections: Int { get }
    var presenter: FacilitiesViewModelPresenter? { get set }
    func screenDidLoad()
    func getNumberOfRows(in section: Int) -> Int
    func getHeader(for section: Int) -> String?
    func getCellViewModel(at indexPath: IndexPath) -> FacilityOptionCellViewModelable?
}

final class FacilitiesViewModel: FacilitiesViewModelable {
    
    /// Display property name as sections and options as cell rows
    private var facilities: [FacilityDetail]
    
    weak var presenter: FacilitiesViewModelPresenter?
    
    private let dataHandler: FacilitiesDataHandler
    
    init() {
        self.facilities = []
        dataHandler = FacilitiesDataHandler()
    }
    
}

// MARK: - Exposed Helpers
extension FacilitiesViewModel {
    
    var numberOfSections: Int {
        return facilities.count
    }
    
    func screenDidLoad() {
        // Fetch response model
        dataHandler.fetchData { [weak self] state in
            switch state {
            case .loading:
                self?.presenter?.startLoading()
            case let .response(model):
                self?.facilities = model.facilities
                self?.presenter?.stopLoading()
                self?.presenter?.reload()
            case let .error(message):
                // TODO
                self?.presenter?.stopLoading()
            }
        }
        // Set navigation title
        presenter?.setNavigationTitle(Constants.facilitiesTitle)
    }
    
    func getNumberOfRows(in section: Int) -> Int {
        guard let facility = facilities[safe: section] else { return 0 }
        return facility.options.count
    }
    
    func getHeader(for section: Int) -> String? {
        guard let facility = facilities[safe: section] else { return nil }
        return facility.name
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> FacilityOptionCellViewModelable? {
        guard let facility = facilities[safe: indexPath.section],
              let option = facility.options[safe: indexPath.item] else { return nil }
        return FacilityOptionCellViewModel(option: option)
    }
    
}
