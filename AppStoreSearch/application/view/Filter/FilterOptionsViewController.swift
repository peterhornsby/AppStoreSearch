//
//  FilterOptionsViewController.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/11/22.
//

import UIKit

class FilterOptionsViewController: UIViewController {

    fileprivate(set) var filterIsActive = false
    // pjh: Work in Progress
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search Filter Options"
        addRightNavigationItem()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    fileprivate func  addRightNavigationItem() {
        let button = UIBarButtonItem.init(barButtonSystemItem: .done,
                                          target: self,
                                          action: #selector(self.doneWithFilterSelection))
        
        navigationItem.setRightBarButton(button, animated: true)
    }

    @objc func doneWithFilterSelection() {
        parent?.dismiss(animated: true)
        
    }
}
