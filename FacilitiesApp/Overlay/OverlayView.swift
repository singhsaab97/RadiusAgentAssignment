//
//  OverlayView.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 29/06/23.
//

import UIKit

final class OverlayView: UIView {

    private struct Style {
        static let backgroundColor = UIColor.secondarySystemBackground
        static let alpha: CGFloat = 0.8
    }
    
    var onTap: (() -> Void)?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Exposed Helpers
extension OverlayView {
    
    func bringToParent(with animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.alpha = Style.alpha
        }
    }
    
    func removeFromParent(with animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.alpha = .zero
        }
    }
    
}

// MARK: - Private Helpers
private extension OverlayView {
    
    func setup() {
        backgroundColor = Style.backgroundColor
        alpha = .zero
        addTapGesture()
    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    func viewTapped() {
        onTap?()
    }
    
}
