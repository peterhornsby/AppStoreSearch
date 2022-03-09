//
//  ViewController.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/8/22.
//

import UIKit
import os.log

class ViewController: UIViewController {
    
    fileprivate var datasource: [AppEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // pjh: testing ONLY
        DataModel.queryForApps(term: "IBM", handle: {_, _ in })
        
    }
}

