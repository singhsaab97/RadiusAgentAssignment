//
//  ViewLoadable.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import UIKit

protocol ViewLoadable {
    static var storyboardName: String { get }
}

extension ViewLoadable where Self: UIViewController {
    
    static func loadFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        // An assumption that every view controller in the storyboard
        // has the same identifier as its class name
        let identifier = String(describing: Self.self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
    
}
