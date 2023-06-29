//
//  ErrorTableViewCell.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 29/06/23.
//

import UIKit

final class ErrorTableViewCell: UITableViewCell,
                                ViewLoadable {
    
    static let nibName = String(describing: ErrorTableViewCell.self)
    static let identifier = String(describing: ErrorTableViewCell.self)
    
    private struct Style {
        static let errorImageTintColor = Constants.primaryColor
        
        static let titleLabelTextColor = UIColor.label
        static let titleLabelFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        static let subtitleLabelTextColor = UIColor.secondaryLabel
        static let subtitleLabelFont = UIFont.systemFont(ofSize: 15)
        
        static let refreshButtonBackgroundColor = errorImageTintColor
        static let refreshButtonTintColor = UIColor.white
        static let refreshButtonFont = UIFont.systemFont(ofSize: 14, weight: .bold)
        static let refreshButtonContentEdgeInsets = UIEdgeInsets(
            top: 14,
            left: 24,
            bottom: 14,
            right: 24
        )
        static let refreshButtonCornerRadius: CGFloat = 16
    }
    
    private var viewModel: ErrorCellViewModelable?
    
    @IBOutlet private weak var errorImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var refreshButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

}

// MARK: - Exposed Helpers
extension ErrorTableViewCell {
    
    func configure(with viewModel: ErrorCellViewModelable) {
        self.viewModel = viewModel
        errorImageView.image = viewModel.state.image?
            .withTintColor(Style.errorImageTintColor)
        titleLabel.text = viewModel.state.title
        subtitleLabel.text = viewModel.state.subtitle
        refreshButton.setTitle(viewModel.refreshButtonTitle, for: .normal)
    }
    
}

// MARK: - Private Helpers
private extension ErrorTableViewCell {
    
    func setup() {
        setupTitleLabel()
        setupSubtitleLabel()
        setupRefreshButton()
    }
    
    func setupTitleLabel() {
        titleLabel.textColor = Style.titleLabelTextColor
        titleLabel.font = Style.titleLabelFont
    }
    
    func setupSubtitleLabel() {
        subtitleLabel.textColor = Style.subtitleLabelTextColor
        subtitleLabel.font = Style.subtitleLabelFont
    }
    
    func setupRefreshButton() {
        refreshButton.backgroundColor = Style.refreshButtonBackgroundColor
        refreshButton.tintColor = Style.refreshButtonTintColor
        refreshButton.titleLabel?.font = Style.refreshButtonFont
        refreshButton.contentEdgeInsets = Style.refreshButtonContentEdgeInsets
        refreshButton.layer.cornerRadius = Style.refreshButtonCornerRadius
    }
    
    @IBAction func refreshButtonTapped() {
        viewModel?.refreshButtonTapped()
    }
    
}
