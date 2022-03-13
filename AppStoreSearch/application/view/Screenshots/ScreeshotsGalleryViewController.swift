//
//  ScreeshotsGalleryViewController.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/11/22.
//

import UIKit
import os.log

class ScreeshotsGalleryViewController: UIViewController {

    @IBOutlet var nextScreenshotButton: UIButton!
    @IBOutlet var screenshotView: UIImageView!
    var searchTerm = ""
    var appEntity: AppEntity!
    var dataSource: [URL] = []
    fileprivate var isProcessAssetRequest = false
    fileprivate var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Screen Shots"
        prepareBackNavigationItem() 

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let _ = appEntity else { return }
        loadScreenshotButton()
        fetchAssets()
    }
    
    // MARK: - UI
    fileprivate func loadScreenshotButton() {
        var text = "Screenshot \(selectedIndex + 1) of \(dataSource.count)"
        if dataSource.count == 0 {
            text = "No Screenshots!"
        }
        nextScreenshotButton.setTitle(text, for: .normal)
    }
    
    
    @IBAction func didRequestNextScreenshot(_ sender: Any) {

        let currentIndex = selectedIndex
        
        
        
        if selectedIndex == dataSource.count - 1 {
            selectedIndex = 0
        } else {
            let newIndex = selectedIndex + 1
            if newIndex < dataSource.count {
                selectedIndex = newIndex
            } else {
                selectedIndex = 0
            }
        }
        
        

        
        var image = FileSystemService.sceenshot(for: appEntity.id,
                                                   term: searchTerm,
                                                   index: selectedIndex)
        if image == nil {
            image = UIImage(named:"general-no-image")
        }

        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .transitionCrossDissolve,
                       animations: {
                            self.screenshotView.image = image
                        },
                       completion: { result in })
        
        
        let text = "Screenshot \(selectedIndex + 1) of \(dataSource.count)"
        nextScreenshotButton.setTitle(text, for: .normal)
    }
    
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
            
            guard self.selectedIndex == index else { return }
            guard let screenshot = FileSystemService.sceenshot(for: appId,
                                                                  term: term,
                                                                  index: index) else { return }
            
            self.screenshotView.image = screenshot
        }
    }
}
