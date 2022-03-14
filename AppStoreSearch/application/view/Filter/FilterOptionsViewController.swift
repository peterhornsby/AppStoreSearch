//
//  FilterOptionsViewController.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/11/22.
//

import UIKit

class FilterOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet var genreListView: UITableView!
    @IBOutlet var freeAppsSwitch: UISwitch!
    @IBOutlet var searchResultsLimitLabel: UILabel!
    @IBOutlet var resultsLimitSlider: UISlider!
    
    var genreDataSource: [String] = []
    var userSelectedSearchLimit = 1
    var filterOnFreeApps = false
    fileprivate(set) var filterIsActive = false
    fileprivate(set) var filterOnGenre = ""
    fileprivate var cellReuseId = "GenreTableViewCellId"
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
        freeAppsSwitch.setOn(filterOnFreeApps, animated: false)
        prepareGenreListView()
        genreListView.reloadData()
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
    

    
    // MARK: - navigation
    @objc func doneWithFilterSelection() {
        parent?.dismiss(animated: true)
    }
    
    
    // MARK: - Genre List view
    fileprivate func prepareGenreListView() {
        genreListView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        genreListView.delegate = self
        genreListView.dataSource = self
        genreListView.layer.cornerRadius = 8
        genreListView.clipsToBounds = true
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if genreDataSource.count == 0 {
            genreListView.isUserInteractionEnabled = false
        } else {
            genreListView.isUserInteractionEnabled = true
        }
        
        return genreDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        
        cell.textLabel?.text = genreDataSource[indexPath.row]
        cell.contentView.backgroundColor = tableView.backgroundColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("get row text and set genre to filter on...")
        if let cell = tableView.cellForRow(at: indexPath) {
            filterOnGenre = cell.textLabel?.text  ?? ""
            cell.contentView.backgroundColor = UIColor.systemBlue
        }

    }
}
