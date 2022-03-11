//
//  AppDetailsViewController.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/10/22.
//

import UIKit

class AppDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dataSource: AppEntity!
    
    fileprivate let appNameCellReuseId = "AppNameReuseId"
    fileprivate let appDescriptionCellReuseId = "AppDescriptionReuseId"
    
    @IBOutlet var detailListView: UITableView!
    var appIcon = UIImage(named: "general-no-image")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        prepareBackNavigationItem()
        prepareDetailListView()
        self.title = "App"
    }
    
    // MARK: - MediaAsset Service Request
    fileprivate func requestMediaForAppEnitity(entity: AppEntity) {
        Task {
            do {
                let results = try await MediaAssetsService.requestForAppIcon(url: entity.artworkURL,
                                                                             appId: entity.id,
                                                                             processAppIcon: { appId, icon in  self.processMediaRequest(appId, icon)})

                print("results: \(results)")

            } catch {
                print("MediaAssets Service Failed: \(error)")
            }
        }
    }
    
    func processMediaRequest(_ appId: UUID,  _ icon:UIImage?) -> () {
        if FileSystemService.saveAppIcon(image: icon, appId: appId) == true {
            DispatchQueue.main.async {
                self.detailListView.reloadData()
            }
        }
    }
    
    
    //MARK: -  UITableView Methods
    fileprivate func prepareDetailListView() {
        // pjh: temp until custom cell
        detailListView.register(AppEntityNameTableViewCell.self, forCellReuseIdentifier: appNameCellReuseId)
        detailListView.register(AppDescriptionTableViewCell.self, forCellReuseIdentifier: appDescriptionCellReuseId)
        detailListView.allowsSelection = false
        detailListView.delegate = self
        detailListView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 1:
            if let cell: AppDescriptionTableViewCell = detailListView.dequeueReusableCell(withIdentifier: appDescriptionCellReuseId) as? AppDescriptionTableViewCell {
                cell.load(dataSource: dataSource)
                return cell
            }
        case 2:
            print(" 3 cell")
        default:
            if let cell: AppEntityNameTableViewCell = detailListView.dequeueReusableCell(withIdentifier: appNameCellReuseId) as? AppEntityNameTableViewCell {
                cell.load(dataSource: dataSource)
                // pjh: check if local, other make request
                if let icon = FileSystemService.appIcon(for: dataSource.id) {
                    cell.icon = icon
                } else {
                    requestMediaForAppEnitity(entity: dataSource)
                }
                return cell
            }
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return 300.0
        case 2:
            return 300.0
        default:
            return 200.0
        }
    }
    
    
    //pjh: navigate to detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    
    fileprivate func prepareBackNavigationItem() {
        let backItem = UIBarButtonItem(image: UIImage(named: "general-back-button"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backItem

    }
    
}
