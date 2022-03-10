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
    fileprivate var dataSource: [AppEntity] = []

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
        dataSource = newAppEntities
        appsListView.reloadData()
    }
    
    
    
    //MARK: -  UITableView Methods
    fileprivate func prepareAppListView() {
        // pjh: temp until custom cell
        appsListView.register(AppEntityTableViewCell.self, forCellReuseIdentifier: cellReuseId)
        
        appsListView.delegate = self
        appsListView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: AppEntityTableViewCell = appsListView.dequeueReusableCell(withIdentifier: cellReuseId) as? AppEntityTableViewCell {
            cell.title = dataSource[indexPath.row].name
            cell.version = dataSource[indexPath.row].version
            cell.size = dataSource[indexPath.row].size
            cell.price = dataSource[indexPath.row].price
            return cell
        }
        
        let cell = AppEntityTableViewCell()
        //cell.appLogoImageView.image = UIImage(named: "general-empty")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard indexPath.row < dataSource.count else { return 0.0 }
        return AppEntityTableViewCell.height
    }
    
}

