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
    func reloadOptions(at indexPaths: [IndexPath])
    func reload()
}

protocol FacilitiesViewModelable {
    var numberOfSections: Int { get }
    var presenter: FacilitiesViewModelPresenter? { get set }
    func screenDidLoad()
    func getNumberOfRows(in section: Int) -> Int
    func getHeader(for section: Int) -> String?
    func getCellViewModel(at indexPath: IndexPath) -> FacilityOptionCellViewModelable?
    func didSelectOption(at indexPath: IndexPath)
}

final class FacilitiesViewModel: FacilitiesViewModelable {
    
    weak var presenter: FacilitiesViewModelPresenter?
    
    private var facilities: [FacilityDetail]
    private var exclusions: [[Exclusion]]
    
    /// Keep a track of every selected option to its corresponding facility id
    private var selectedOptionsDict: [String: FacilityOption]
    /// Keep a track of every excluded option
    private var excludedOptions: [FacilityOption]
    
    private let dataHandler: FacilitiesDataHandler
    
    init() {
        self.facilities = []
        self.exclusions = []
        self.selectedOptionsDict = [:]
        self.excludedOptions = []
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
                self?.exclusions = model.exclusions
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
        var state = FacilityOptionCellViewModel.State.deselected
        if excludedOptions.contains(option) {
            state = .disabled
        } else if selectedOptionsDict[facility.id] == option {
            state = .selected
        }
        return FacilityOptionCellViewModel(option: option, state: state)
    }
    
    func didSelectOption(at indexPath: IndexPath) {
        guard let facility = facilities[safe: indexPath.section],
              let option = facility.options[safe: indexPath.item] else { return }
        if selectedOptionsDict.contains(where: { $0.key == facility.id }) {
            // Check for unique selection within a facility
            if selectedOptionsDict[facility.id] == option {
                // Deselect this option
                selectedOptionsDict.removeValue(forKey: facility.id)
                presenter?.reloadOptions(at: [indexPath])
                // TODO: Show everything enabled
            } else {
                var indexPaths = [IndexPath]()
                if let optionId = selectedOptionsDict[facility.id]?.id,
                   let index = facility.options.firstIndex(where: { $0.id == optionId }) {
                    let indexPath = IndexPath(row: index, section: indexPath.section)
                    indexPaths.append(indexPath)
                }
                // Select this option
                selectedOptionsDict[facility.id] = option
                indexPaths.append(indexPath)
                presenter?.reloadOptions(at: indexPaths)
                DispatchQueue.main.async { [weak self] in
                    self?.updateAvailableOptions(for: facility, option: option)
                }
            }
        } else {
            // Selecting in another facility
            selectedOptionsDict[facility.id] = option
            presenter?.reloadOptions(at: [indexPath])
            DispatchQueue.main.async { [weak self] in
                self?.updateAvailableOptions(for: facility, option: option)
            }
        }
    }
    
}

// MARK: - Private Helpers
private extension FacilitiesViewModel {
    
    func updateAvailableOptions(for facility: FacilityDetail, option: FacilityOption) {
        excludedOptions.removeAll()
        // Retrieve exclusions for the selected option
        let exclusionsForOption = exclusions.filter { exclusionSet in
            return exclusionSet.contains { exclusion in
                return exclusion.facilityId == facility.id && exclusion.optionId == option.id
            }
        }
        // Identify the excluded facility options
        exclusionsForOption.forEach { exclusionSet in
            for exclusion in exclusionSet where exclusion.facilityId != facility.id {
                if let excludedOption = facilities.first(where: {
                    return $0.id == exclusion.facilityId
                })?.options.first(where: {
                    return $0.id == exclusion.optionId
                }) {
                    excludedOptions.append(excludedOption)
                }
            }
        }
        var indexPaths = [IndexPath]()
        facilities.enumerated().forEach { (sectionIndex, facility) in
            for (rowIndex, option) in facility.options.enumerated() where excludedOptions.contains(option) {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                indexPaths.append(indexPath)
            }
        }
        presenter?.reloadOptions(at: indexPaths)
    }
    
}
