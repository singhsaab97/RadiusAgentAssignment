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
    
    private struct Style {
        static let optionNameLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    @IBOutlet private weak var optionImageView: UIImageView!
    @IBOutlet private weak var optionNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

}

// MARK: - Exposed Helpers
extension FacilityOptionTableViewCell {
    
    func configure(with viewModel: FacilityOptionCellViewModelable) {
        optionImageView.image = UIImage(named: viewModel.option.icon)
        optionNameLabel.text = viewModel.option.name
    }
    
}

// MARK: - Private Helpers
private extension FacilityOptionTableViewCell {
    
    func setup() {
        optionNameLabel.font = Style.optionNameLabelFont
    }
    
}
