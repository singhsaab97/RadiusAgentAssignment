//
//  BookingConfirmationViewModel.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 29/06/23.
//

import UIKit

protocol BookingConfirmationViewModelable {
    var image: UIImage? { get }
    var title: String { get }
    var subtitle: String { get }
    var facilityOptions: String { get }
}

final class BookingConfirmationViewModel: BookingConfirmationViewModelable {
    
    let facilityOptions: String
    
    init(facilityOptions: String) {
        self.facilityOptions = facilityOptions
    }
    
}

// MARK: - Exposed Helpers
extension BookingConfirmationViewModel {
    
    var image: UIImage? {
        return UIImage(named: "success")
    }
    
    var title: String {
        return Constants.bookingConfirmedTitle
    }
    
    var subtitle: String {
        return "\(Constants.bookingConfirmedSubtitle) \(facilityOptions)"
    }
    
}
