//
//  BookingConfirmationView.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 29/06/23.
//

import UIKit

final class BookingConfirmationView: UIView,
                                     ViewLoadable {
    
    static let nibName = String(describing: BookingConfirmationView.self)
    static let identifier = String(describing: BookingConfirmationView.self)
    
    private struct Style {
        static let backgroundColor = UIColor.systemBackground
        static let cornerRadius: CGFloat = 16
        static let springDamping: CGFloat = 0.7
        static let zeroTransform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        static let closeButtonTintColor = Constants.primaryColor
        
        static let successImageTintColor = closeButtonTintColor
        
        static let titleLabelTextColor = UIColor.label
        static let titleLabelFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        static let subtitleLabelTextColor = UIColor.secondaryLabel
        static let subtitleLabelFont = UIFont.systemFont(ofSize: 15)
    }
    
    var viewModel: BookingConfirmationViewModelable? {
        didSet {
            setup()
        }
    }
    
    var onCloseTap: (() -> Void)?
    
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var successImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
}

// MARK: - Exposed Helpers
extension BookingConfirmationView {
    
    func bringToParent(with animationDuration: TimeInterval) {
        transform = Style.zeroTransform
        UIView.animate(
            withDuration: animationDuration,
            delay: .zero,
            usingSpringWithDamping: Style.springDamping,
            initialSpringVelocity: .zero
        ) { [weak self] in
            self?.transform = .identity
        }
    }
    
    func removeFromParent(with animationDuration: TimeInterval, completion: @escaping () -> Void) {
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.alpha = .zero
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
            completion()
        }
    }
    
}

// MARK: - Private Helpers
private extension BookingConfirmationView {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        layer.cornerRadius = Style.cornerRadius
        setupCloseButton()
        setupSuccessImageView()
        setupTitleLabel()
        setupSubtitleLabel()
    }
    
    func setupCloseButton() {
        closeButton.tintColor = Style.closeButtonTintColor
        closeButton.setImage(viewModel?.closeButtonImage, for: .normal)
        closeButton.setTitle(nil, for: .normal)
    }
    
    func setupSuccessImageView() {
        successImageView.image = viewModel?.confirmationImage?
            .withTintColor(Style.successImageTintColor)
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = Style.titleLabelTextColor
        titleLabel.font = Style.titleLabelFont
        titleLabel.text = viewModel?.title
    }
    
    func setupSubtitleLabel() {
        subtitleLabel.textColor = Style.subtitleLabelTextColor
        subtitleLabel.font = Style.subtitleLabelFont
        subtitleLabel.text = viewModel?.subtitle
    }
    
    @IBAction func closeButtonTapped() {
        viewModel?.closeButtonTapped()
    }
    
}

// MARK: - BookingConfirmationViewModelPresenter Methods
extension BookingConfirmationView: BookingConfirmationViewModelPresenter {
    
    func invokeCloseCallback() {
        onCloseTap?()
    }
    
}
