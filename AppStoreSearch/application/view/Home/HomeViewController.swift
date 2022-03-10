//
//  ViewController.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/8/22.
//

import UIKit
import os.log

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var emptyQueryView: UIView!
    @IBOutlet var appStoreSearchBar: UISearchBar!
    
    @IBOutlet var emptySearchQueryResultLabel: UILabel!
    @IBOutlet weak var appsListView: UITableView!
    
    fileprivate let cellReuseId = "AppEntityReuseId"
    fileprivate var dataSource: [AppEntity] = []

    //MARK: -  UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAppListView()
        prepareSearchBar()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    fileprivate func updateAppsListView(_ newAppEntities: [AppEntity]) {
        dataSource = newAppEntities
        
        if dataSource.count == 0 {
            UIView.animate(withDuration: 0.3) {
                self.emptyQueryView.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.emptyQueryView.alpha = 0.0
            }
        }
        
        appsListView.reloadData()
    }
    

    
    //MARK: -  SearchBar Methods
    fileprivate func prepareSearchBar() {
        appStoreSearchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchTerm = searchBar.text {
            // pjh: ToDo: check return values
            guard searchTerm.isEmpty == false else {
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                    self.updateAppsListView([])
                }
                return
            }
            
            let _ = DataModel.queryForApps(term: searchTerm, handle: {newAppEntities, _ in
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                    self.updateAppsListView(newAppEntities)
                }
            })
        }
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
            cell.appId = dataSource[indexPath.row].id
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if appStoreSearchBar.isFirstResponder {
            appStoreSearchBar.resignFirstResponder()
        }
    }
    
}

