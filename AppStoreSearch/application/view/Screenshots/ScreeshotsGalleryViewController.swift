//
//  ScreeshotsGalleryViewController.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/11/22.
//

import UIKit
import os.log

class ScreeshotsGalleryViewController: UIViewController {
    var searchTerm = ""
    var appEntity: AppEntity!
    var dataSource: [URL] = []
    fileprivate var isProcessAssetRequest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Screen Shots"
        prepareBackNavigationItem() 

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let _ = appEntity else { return }
        fetchAssets()
    }
    
    // MARK: - UI
    

    // MARK: - MediaAssetService
    func fetchAssets() {
        // pjh: Limit the number of asset requests
        guard isProcessAssetRequest == false else {
            Logger().info("\(#function): Screenshot request(s) ARE being processed")
            return
        }
        
        
        Task {
            do {
                let action = { appId, icon, term, errorType in  self.processMediaRequest(appId, icon, term, errorType)}
                let results = try await MediaAssetsService.requestForAllScreenshots(appId: appEntity.id,
                                                                                    urls: dataSource,
                                                                                    term: searchTerm,
                                                                                    process: action)

                print("results: \(results)")

            } catch {
                print("MediaAssets Service Failed: \(error)")
            }
        }
        
        
        
        
    }

    func processMediaRequest(_ appId: UUID,
                             _ term: String,
                             _ index: Int,
                             _ applicationErrorType: ApplicationErrorType) -> () {
        DispatchQueue.main.async {
            print("Screenshot at index: \(index) is ready to display!!")
            if self.dataSource.count == 0 || (self.dataSource.count - 1) == index {
                self.isProcessAssetRequest = false
            } else {
                self.isProcessAssetRequest = true
            }
        }
    }
}
