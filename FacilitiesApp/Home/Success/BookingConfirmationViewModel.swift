//
//  BookingConfirmationViewModel.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 29/06/23.
//

import UIKit

protocol BookingConfirmationViewModelPresenter: AnyObject {
    func invokeCloseCallback()
}

protocol BookingConfirmationViewModelable {
    var closeButtonImage: UIImage? { get }
    var confirmationImage: UIImage? { get }
    var title: String { get }
    var subtitle: String { get }
    var facilityOptions: String { get }
    var presenter: BookingConfirmationViewModelPresenter? { get set }
    func closeButtonTapped()
}

final class BookingConfirmationViewModel: BookingConfirmationViewModelable {
    
    let facilityOptions: String
    
    weak var presenter: BookingConfirmationViewModelPresenter?
    
    init(facilityOptions: String) {
        self.facilityOptions = facilityOptions
    }
    
}

// MARK: - Exposed Helpers
extension BookingConfirmationViewModel {
    
    var closeButtonImage: UIImage? {
        return UIImage(named: "close")
    }
    
    var confirmationImage: UIImage? {
        return UIImage(named: "success")
    }
    
    var title: String {
        return Constants.bookingConfirmedTitle
    }
    
    var subtitle: String {
        return "\(Constants.bookingConfirmedSubtitle) \(facilityOptions)"
    }
    
    func closeButtonTapped() {
        presenter?.invokeCloseCallback()
    }
    
}
