//
//  AppDetailsViewController.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/10/22.
//

import UIKit

class AppDetailsViewController: UIViewController {

    var dataSource: AppEntity!
    var appIcon = UIImage(named: "general-no-image")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        prepareBackNavigationItem()
        print("App entity: \(dataSource)")
        self.title = "App"
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
