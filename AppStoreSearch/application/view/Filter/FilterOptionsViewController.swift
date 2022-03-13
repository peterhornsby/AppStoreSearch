//
//  FilterOptionsViewController.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/11/22.
//

import UIKit

class FilterOptionsViewController: UIViewController {

    @IBOutlet var searchResultsLimitLabel: UILabel!
    @IBOutlet var resultsLimitSlider: UISlider!
    var userSelectedSearchLimit = 1
    fileprivate(set) var filterIsActive = false
    fileprivate(set) var filterOnFreePrice = false
    fileprivate(set) var filterOnCategory = ""
    // pjh: Work in Progress
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Filter Options"
        addRightNavigationItem(action: #selector(self.doneWithFilterSelection))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultsLimitSlider.value = Float(userSelectedSearchLimit)
        searchResultsLimitLabel.text = "\(userSelectedSearchLimit)"
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        processFilterSelections?(self)
    }
    
    
    var processFilterSelections: ((FilterOptionsViewController) -> ())?
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Slider
    
    
    @IBAction func sliderValueDidChange(_ sender: UISlider) {
        let newValue = Int(sender.value)
        searchResultsLimitLabel.text = "\(newValue)"
        userSelectedSearchLimit = newValue
        
    }
    
    @objc func doneWithFilterSelection() {
        parent?.dismiss(animated: true)
    }
}
