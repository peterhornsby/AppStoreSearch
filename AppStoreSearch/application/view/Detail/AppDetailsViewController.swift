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
    var searchTerm = ""
    
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
            } catch {
                // pjh: ToDo: handle errors in ui
                print("MediaAssets Service Failed: \(error)")
            }
        }
    }
    
    func processMediaRequest(_ appId: Int64,  _ rawData: Data?) -> () {
        FileSystemService.saveAppIcon(rawData: rawData, appId: appId, term: searchTerm)
        DispatchQueue.main.async {
            self.detailListView.reloadData()
        }
    }
    

    @objc func didRequestToViewScreenhots() {
        print("Well, go and get the screen shots!!")
        let screenshotURLs = MediaAssetsService.screenshotURLs(for: dataSource.id, term: searchTerm)
        print("screenShot URLs: \(screenshotURLs)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let screenshotViewController = storyboard.instantiateViewController(withIdentifier: "ScreenshotsView") as! ScreeshotsGalleryViewController
        screenshotViewController.appEntity = dataSource
        screenshotViewController.searchTerm = searchTerm
        screenshotViewController.dataSource = screenshotURLs
        
        navigationController?.pushViewController(screenshotViewController, animated: true)
    }
    
    
    //MARK: -  UITableView Methods
    fileprivate func prepareDetailListView() {
        // pjh: temp until custom cell
        detailListView.register(AppEntityNameTableViewCell.self, forCellReuseIdentifier: appNameCellReuseId)
        detailListView.register(AppEntityDescriptionTableViewCell.self, forCellReuseIdentifier: appDescriptionCellReuseId)
        detailListView.allowsSelection = false
        detailListView.delegate = self
        detailListView.dataSource = self
        detailListView.tableFooterView = footerForDetailsListView()
    }
    
    func footerForDetailsListView() -> UIView {
        var frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let containerView = UIView(frame: frame)
        frame.size.width = containerView.frame.size.width - 120.0
        let button = UIButton(type: .system)
        button.frame = frame
        button.addTarget(self, action: #selector(self.didRequestToViewScreenhots), for: .touchUpInside)
        button.center = containerView.center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        button.setTitle("Screenshots", for: .normal)
        containerView.addSubview(button)
        containerView.backgroundColor = UIColor.white
        
        return containerView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 1:
            if let cell: AppEntityDescriptionTableViewCell = detailListView.dequeueReusableCell(withIdentifier: appDescriptionCellReuseId) as? AppEntityDescriptionTableViewCell {
                cell.load(dataSource: dataSource)
                return cell
            }
        case 2:
            print(" 3 cell")
        default:
            if let cell: AppEntityNameTableViewCell = detailListView.dequeueReusableCell(withIdentifier: appNameCellReuseId) as? AppEntityNameTableViewCell {
                cell.load(dataSource: dataSource)
                // pjh: check if local, other make request
                if let icon = FileSystemService.appIcon(for: dataSource.id, term: searchTerm) {
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
        case 0:
            return AppEntityNameTableViewCell.height
        default:
            return AppEntityDescriptionTableViewCell.height
        }
    }
    
    
    //pjh: navigate to detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    
}


