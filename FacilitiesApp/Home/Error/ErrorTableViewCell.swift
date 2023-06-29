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
    }
    
    @IBOutlet private weak var errorImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

}

// MARK: - Exposed Helpers
extension ErrorTableViewCell {
    
    func configure(with viewModel: ErrorCellViewModelable) {
        errorImageView.image = viewModel.state.image?
            .withTintColor(Style.errorImageTintColor)
        titleLabel.text = viewModel.state.title
        subtitleLabel.text = viewModel.state.subtitle
    }
    
}

// MARK: - Private Helpers
private extension ErrorTableViewCell {
    
    func setup() {
        titleLabel.textColor = Style.titleLabelTextColor
        titleLabel.font = Style.titleLabelFont
        subtitleLabel.textColor = Style.subtitleLabelTextColor
        subtitleLabel.font = Style.subtitleLabelFont
    }
    
}
