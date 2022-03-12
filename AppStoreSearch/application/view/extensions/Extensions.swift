//
//  Extensions.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/12/22.
//

import Foundation
import UIKit


public extension UIViewController {
    func prepareBackNavigationItem() {
        let backItem = UIBarButtonItem(image: UIImage(named: "general-back-button"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backItem

    }
    
    func  addRightNavigationItem(action: Selector?) {
        let button = UIBarButtonItem.init(barButtonSystemItem: .done,
                                          target: self,
                                          action: action)
        
        navigationItem.setRightBarButton(button, animated: true)
    }
}
