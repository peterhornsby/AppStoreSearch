//
//  ScreeshotsGalleryViewController.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/11/22.
//

import UIKit

class ScreeshotsGalleryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Screen Shots"
        prepareBackNavigationItem() 
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    fileprivate func prepareBackNavigationItem() {
        let backItem = UIBarButtonItem(image: UIImage(named: "general-back-button"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backItem

    }
}
