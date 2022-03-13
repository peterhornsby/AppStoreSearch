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
        // pjh: prep work for filters
        addFilterNavigationItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectCell()
    }
    
    fileprivate func deselectCell() {
        guard let index = appsListView.indexPathForSelectedRow else { return }
        appsListView.deselectRow(at: index, animated: false)
    }
    
    // MARK:- Filtering
    // pjh: Work in Progress
    fileprivate func  addFilterNavigationItem() {
        let image =  UIImage(named: "filter-active-button")
        let button = UIBarButtonItem(image: image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(self.showFilters))
        
        navigationItem.setRightBarButton(button, animated: true)
    }
    
    @objc func showFilters() {
        print("Show filters!!")
        let filterNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterOptionsNavigation") as! UINavigationController
        
        
        self.present(filterNavigationController, animated: true, completion: nil)
    }
    
    
    // MARK: - Search Query Updates
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
                    DataModel.deleteALLPreviousSearchResults()
                    searchBar.resignFirstResponder()
                    self.updateAppsListView([])
                }
                return
            }
            
            let _ = DataModel.queryForApps(term: searchTerm, handle: {newAppEntities, _ in
                DispatchQueue.main.async {
                    DataModel.deleteALLPreviousSearchResults() 
                    self.updateAppsListView([])
                    searchBar.resignFirstResponder()
                    self.updateAppsListView(newAppEntities)
                }
            })
        }
    }
    
    // MARK: - MediaAsset Service Request
    fileprivate func requestMediaForAppEnitity(entity: AppEntity) {
        Task {
            do {
                let term = appStoreSearchBar.text ?? ""
                let results = try await MediaAssetsService.requestForAppIcon(url: entity.artworkURL,
                                                                             appId: entity.id,
                                                                             processAppIcon: { appId, icon in  self.processMediaRequest(appId, icon, term)})

                print("results: \(results)")

            } catch {
                print("MediaAssets Service Failed: \(error)")
            }
        }
    }
    
    func processMediaRequest(_ appId: UUID,  _ data: Data?, _ term: String) {
        FileSystemService.saveAppIcon(rawData: data, appId: appId, term: term)
        DispatchQueue.main.async {
            self.updateAppsListView(self.dataSource)
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
        let appEntity = dataSource[indexPath.row]
        let searchTerm = appStoreSearchBar.text ?? ""
        if let cell: AppEntityTableViewCell = appsListView.dequeueReusableCell(withIdentifier: cellReuseId) as? AppEntityTableViewCell {
            cell.load(dataSource: appEntity)
            // pjh: check if local, other make request
            if let icon = FileSystemService.appIcon(for: appEntity.id, term: searchTerm) {
                cell.icon = icon
            } else {
                requestMediaForAppEnitity(entity: appEntity)
            }
            
            return cell
        }
        
        let cell = AppEntityTableViewCell()
        cell.load(dataSource: appEntity)
        if let icon = FileSystemService.appIcon(for: appEntity.id, term: searchTerm) {
            cell.icon = icon
        } else {
            requestMediaForAppEnitity(entity: appEntity)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard indexPath.row < dataSource.count else { return 0.0 }
        return AppEntityTableViewCell.height
    }
    
    
    //pjh: navigate to detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if appStoreSearchBar.isFirstResponder {
            appStoreSearchBar.resignFirstResponder()
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailView") as! AppDetailsViewController
        detailViewController.dataSource = dataSource[indexPath.row]
        detailViewController.searchTerm = appStoreSearchBar.text ?? ""
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

