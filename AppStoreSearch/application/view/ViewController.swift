//
//  ViewController.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/8/22.
//

import UIKit
import os.log

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var appsListView: UITableView!
    
    fileprivate let cellReuseId = "AppEntityReuseId"
    fileprivate var datasource: [AppEntity] = []

    //MARK: -  UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAppListView()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // pjh: testing ONLY
        DataModel.queryForApps(term: "IBM", handle: {newAppEntities, _ in
            DispatchQueue.main.async {
                self.updateAppsListView(newAppEntities)
            }
        })
    }
    
    
    fileprivate func updateAppsListView(_ newAppEntities: [AppEntity]) {
        datasource = newAppEntities
        appsListView.reloadData()
    }
    
    
    
    //MARK: -  UITableView Methods
    fileprivate func prepareAppListView() {
        // pjh: temp until custom cell
        appsListView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        
        appsListView.delegate = self
        appsListView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = appsListView.dequeueReusableCell(withIdentifier: cellReuseId)! as UITableViewCell
        
        return cell
    }
    
}

