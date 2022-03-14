//
//  FilterOptionsViewController.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/11/22.
//

import UIKit

class FilterOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet var genreListView: UITableView!
    @IBOutlet var filterOnGenreSwitch: UISwitch!
    @IBOutlet var freeAppsSwitch: UISwitch!
    @IBOutlet var searchResultsLimitLabel: UILabel!
    @IBOutlet var resultsLimitSlider: UISlider!
    
    var genreDataSource: [String] = []
    var userSelectedSearchLimit = 1
    var filterOnFreeApps = false
    var filterOnGenre = false
    fileprivate(set) var filterIsActive = false
    fileprivate(set) var filterOnGenreTerm = ""
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
        filterOnGenreSwitch.setOn(filterOnFreeApps, animated: false)
        if genreDataSource.count == 0 {
            genreListView.isUserInteractionEnabled = false
            filterOnGenreSwitch.setOn(false, animated: false)
            filterOnGenreSwitch.isUserInteractionEnabled = false
        }
        
        filterOnGenreSwitch.setOn(false, animated: false)
        
        prepareGenreListView()
        genreListView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        processFilterSelections?(self)
    }
    
    
    var processFilterSelections: ((FilterOptionsViewController) -> ())?
    
    
    @IBAction func didSelectGenreFilter(_ sender: UISwitch) {
        if sender.isOn == true {
            genreListView.isUserInteractionEnabled = true
        } else {
            filterOnGenre = false
            filterOnGenreTerm = ""
        }

        let message = "pjh: filtering on genre is a WORK in Progress. Please read the readme with the app code."
        let alert = UIAlertController(title: "Work In Progress", message: message, preferredStyle: .alert)
                                      
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            //pjh: message?
            self.filterOnGenreSwitch.setOn(false, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        genreListView.reloadData()
    }
    
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
        if let text = cell.textLabel?.text {
            if text == filterOnGenreTerm {
                cell.contentView.backgroundColor = UIColor.systemBlue
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("get row text and set genre to filter on...")
        if let cell = tableView.cellForRow(at: indexPath) {
            filterOnGenreTerm = cell.textLabel?.text  ?? ""
            cell.contentView.backgroundColor = UIColor.systemBlue
            filterOnGenreSwitch.setOn(true, animated: true)
            genreListView.reloadData()
            let message = "pjh: filtering on genre is a WORK in Progress. Please read the readme with the app code."
            let alert = UIAlertController(title: "Work In Progress", message: message, preferredStyle: .alert)
                                          
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                //pjh: message?
                self.filterOnGenreSwitch.setOn(false, animated: true)
                self.filterOnGenreTerm = ""
                self.genreListView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }

    }
}
