//
//  FacilitiesViewModel.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import Foundation

protocol FacilitiesViewModelPresenter: AnyObject {
    func setNavigationTitle(_ title: String)
    func updateSelectButtonTitle()
    func updateConfirmButtonState()
    func startLoading()
    func stopLoading()
    func reloadOptions(at indexPaths: [IndexPath])
    func reload()
}

protocol FacilitiesViewModelable {
    var selectButtonTitle: String { get }
    var confirmButtonTitle: String { get }
    var isConfirmButtonEnabled: Bool { get }
    var numberOfSections: Int { get }
    var presenter: FacilitiesViewModelPresenter? { get set }
    func screenDidLoad()
    func selectButtonTapped()
    func confirmButtonTapped()
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
    private var selectedOptionsDict: [String: FacilityOption] {
        didSet {
            presenter?.updateConfirmButtonState()
        }
    }
    /// Keep a track of every excluded option
    private var excludedOptions: [FacilityOption]
    private var isSelectionEnabled: Bool
    
    private let dataHandler: FacilitiesDataHandler
    
    init() {
        self.facilities = []
        self.exclusions = []
        self.selectedOptionsDict = [:]
        self.excludedOptions = []
        self.isSelectionEnabled = true
        dataHandler = FacilitiesDataHandler()
    }
    
}

// MARK: - Exposed Helpers
extension FacilitiesViewModel {
    
    var selectButtonTitle: String {
        return isSelectionEnabled ? Constants.cancelTitle : Constants.selectTitle
    }
    
    var confirmButtonTitle: String {
        return Constants.confirmTitle
    }
    
    var isConfirmButtonEnabled: Bool {
        return !selectedOptionsDict.isEmpty
    }
    
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
    
    func selectButtonTapped() {
        isSelectionEnabled = !isSelectionEnabled
        presenter?.updateSelectButtonTitle()
        presenter?.reload()
    }
    
    func confirmButtonTapped() {
        // TODO
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
        if !isSelectionEnabled {
            state = .idle
        } else if excludedOptions.contains(option) {
            state = .disabled
        } else if selectedOptionsDict[facility.id] == option {
            state = .selected
        }
        return FacilityOptionCellViewModel(option: option, state: state)
    }
    
    func didSelectOption(at indexPath: IndexPath) {
        guard isSelectionEnabled,
              let facility = facilities[safe: indexPath.section],
              let option = facility.options[safe: indexPath.item] else { return }
        if selectedOptionsDict.contains(where: { $0.key == facility.id }) {
            // Check for unique selection within a facility
            if selectedOptionsDict[facility.id] == option {
                // Deselect this option
                selectedOptionsDict.removeValue(forKey: facility.id)
                presenter?.reloadOptions(at: [indexPath])
                enableAvailableOptions(for: facility, option: option)
            } else {
                var indexPaths = [IndexPath]()
                if let option = selectedOptionsDict[facility.id],
                   let index = facility.options.firstIndex(where: { $0.id == option.id }) {
                    enableAvailableOptions(for: facility, option: option)
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
    
    func enableAvailableOptions(for facility: FacilityDetail, option: FacilityOption) {
        // Enable selection for these options
        let options = getExcludedOptions(for: facility, option: option)
        var indexPaths = [IndexPath]()
        facilities.enumerated().forEach { (sectionIndex, facility) in
            for (rowIndex, option) in facility.options.enumerated() where options.contains(option) {
                let previouslyExcludedOptions = getExcludedOptions(for: facility, option: option)
                if !previouslyExcludedOptions.contains(option) {
                    excludedOptions.removeAll(where: { $0 == option })
                }
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                indexPaths.append(indexPath)
            }
        }
        presenter?.reloadOptions(at: indexPaths)
    }
    
    func updateAvailableOptions(for facility: FacilityDetail, option: FacilityOption) {
        excludedOptions.removeAll()
        let options = getExcludedOptions(for: facility, option: option)
        options.forEach { option in
            excludedOptions.append(option)
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
    
    func getExcludedOptions(for facility: FacilityDetail, option: FacilityOption) -> [FacilityOption] {
        var excludedOptions = [FacilityOption]()
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
        return excludedOptions
    }
    
}
