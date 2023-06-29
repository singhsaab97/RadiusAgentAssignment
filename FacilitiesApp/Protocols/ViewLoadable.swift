//
//  ViewLoadable.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import UIKit

protocol ViewLoadable {
    static var nibName: String { get }
    static var identifier: String { get }
}

extension ViewLoadable where Self: UITableViewCell {
    
    static func register(for tableView: UITableView) {
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    static func dequeReusableCell(from tableView: UITableView, at indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath
        ) as! Self
    }
    
}

extension ViewLoadable where Self: UIView {
    
    static func loadFromNib() -> Self {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
    
}
