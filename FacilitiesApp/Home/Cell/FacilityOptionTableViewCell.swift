//
//  FacilityOptionTableViewCell.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import UIKit

final class FacilityOptionTableViewCell: UITableViewCell,
                                         ViewLoadable {
    
    static let nibName = String(describing: FacilityOptionTableViewCell.self)
    static let identifier = String(describing: FacilityOptionTableViewCell.self)
    
    fileprivate struct Style {
        static let selectionViewSelectedBorderColor = Constants.primaryColor
        static let selectionViewDeselectedBorderColor = UIColor.systemGray2
        static let selectionViewDisabledBorderColor = UIColor.clear
        
        static let selectionFillViewSelectedBackgroundColor = selectionViewSelectedBorderColor
        static let selectionFillViewDeselectedBackgroundColor = UIColor.clear
        static let selectionFillViewDisabledBackgroundColor = selectionViewDisabledBorderColor
        
        static let optionImageDefaultTintColor = selectionViewSelectedBorderColor
        static let optionImageDisabledTintColor = UIColor.systemGray2
        
        static let nameLabelDefaultTextColor = UIColor.label
        static let nameLabelDisabledTextColor = UIColor.systemGray2
        
        static let unavailableLabelDefaultTextColor = UIColor.clear
        static let unavailableLabelDisabledTextColor = nameLabelDisabledTextColor

        static let optionNameLabelFont = UIFont.systemFont(ofSize: 15)
        static let unavailableLabelFont = UIFont.italicSystemFont(ofSize: 14)
        static let selectionViewBorderWidth: CGFloat = 1.5
    }
    
    @IBOutlet private weak var selectionView: UIView!
    @IBOutlet private weak var selectionFillView: UIView!
    @IBOutlet private weak var optionImageView: UIImageView!
    @IBOutlet private weak var optionNameLabel: UILabel!
    @IBOutlet private weak var unavailableLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
    }

}

// MARK: - Exposed Helpers
extension FacilityOptionTableViewCell {
    
    func configure(with viewModel: FacilityOptionCellViewModelable) {
        selectionView.layer.borderColor = viewModel.state.selectionViewBorderColor.cgColor
        selectionFillView.backgroundColor = viewModel.state.selectionFillViewBackgroundColor
        selectionView.isHidden = viewModel.state.isSelectionViewHidden
        optionImageView.image = UIImage(named: viewModel.option.icon)?
            .withTintColor(viewModel.state.optionImageTintColor)
        optionNameLabel.textColor = viewModel.state.nameLabelTextColor
        optionNameLabel.text = viewModel.option.name
        unavailableLabel.textColor = viewModel.state.unavailableLabelTextColor
        unavailableLabel.text = viewModel.state.unavailableText
        unavailableLabel.isHidden = viewModel.state.isUnavailableLabelHidden
        isUserInteractionEnabled = viewModel.state.isUserInteractionEnabled
    }
    
}

// MARK: - Private Helpers
private extension FacilityOptionTableViewCell {
    
    func setup() {
        selectionView.layer.borderWidth = Style.selectionViewBorderWidth
        optionNameLabel.font = Style.optionNameLabelFont
        unavailableLabel.font = Style.unavailableLabelFont
    }
    
    func setCornerRadius() {
        selectionView.layer.cornerRadius = min(
            selectionView.bounds.width,
            selectionView.bounds.height
        ) / 2
        selectionFillView.layer.cornerRadius = min(
            selectionFillView.bounds.width,
            selectionFillView.bounds.height
        ) / 2
    }
    
}

// MARK: - FacilityOptionCellViewModel.State Helpers
private extension FacilityOptionCellViewModel.State {
    
    var selectionViewBorderColor: UIColor {
        switch self {
        case .selected:
            return FacilityOptionTableViewCell.Style.selectionViewSelectedBorderColor
        case .deselected:
            return FacilityOptionTableViewCell.Style.selectionViewDeselectedBorderColor
        case .idle, .disabled:
            return FacilityOptionTableViewCell.Style.selectionViewDisabledBorderColor
        }
    }
    
    var selectionFillViewBackgroundColor: UIColor {
        switch self {
        case .selected:
            return FacilityOptionTableViewCell.Style.selectionFillViewSelectedBackgroundColor
        case .deselected:
            return FacilityOptionTableViewCell.Style.selectionFillViewDeselectedBackgroundColor
        case .idle, .disabled:
            return FacilityOptionTableViewCell.Style.selectionFillViewDisabledBackgroundColor
        }
    }
    
    var optionImageTintColor: UIColor {
        switch self {
        case .idle, .selected, .deselected:
            return FacilityOptionTableViewCell.Style.optionImageDefaultTintColor
        case .disabled:
            return FacilityOptionTableViewCell.Style.optionImageDisabledTintColor
        }
    }
    
    var nameLabelTextColor: UIColor {
        switch self {
        case .idle, .selected, .deselected:
            return FacilityOptionTableViewCell.Style.nameLabelDefaultTextColor
        case .disabled:
            return FacilityOptionTableViewCell.Style.nameLabelDisabledTextColor
        }
    }
    
    var unavailableLabelTextColor: UIColor {
        switch self {
        case .idle, .selected, .deselected:
            return FacilityOptionTableViewCell.Style.unavailableLabelDefaultTextColor
        case .disabled:
            return FacilityOptionTableViewCell.Style.unavailableLabelDisabledTextColor
        }
    }
    
}
