//
//  ViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 02/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearch
import AlgoliaSearch

class ItemTableViewController: UIViewController, UITableViewDelegate, HitsTableViewDataSource {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var tableView: HitsTableWidget!
    @IBOutlet weak var searchBarNavigationItem: UINavigationItem!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var nbHitsLabel: UILabel!
    
    var hitsController: HitsController!

    
    var searchController: UISearchController!
    var isFilterClicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureToolBar()
        configureSearchController()
        configureTable()
        configureInstantSearch()
        
        hitsController = HitsController(table: tableView)
        tableView.dataSource = hitsController
        tableView.delegate = hitsController
        hitsController.tableDataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! ItemCell
        
        // TODO: Solve it better with data binding techniques
        cell.item = ItemRecord(json: hit)
        
        cell.backgroundColor = ColorConstants.tableColor
        
        return cell
    }
    
    // MARK: Helper methods for configuring each component of the table
    
    func configureInstantSearch() {
        //instantSearch = InstantSearch(algoliaSearchProtocol: AlgoliaSearchManager.instance, searchController: searchController)
        //instantSearch.hitDataSource = self
        
        InstantSearch.reference.add(searchController: searchController)
        InstantSearch.reference.addAllWidgets(in: self.view)
    }
    
    func configureTable() {
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.backgroundColor = ColorConstants.tableColor
    }
    
    func configureNavBar() {
        navigationController?.navigationBar.barTintColor = ColorConstants.barBackgroundColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : ColorConstants.barTextColor]
    }
    
    func configureToolBar() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(filterClicked))
        singleTap.numberOfTapsRequired = 1 // you can change this value
        arrowImageView.isUserInteractionEnabled = true
        arrowImageView.addGestureRecognizer(singleTap)
        topBarView.backgroundColor = ColorConstants.tableColor
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search items"
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.barTintColor = ColorConstants.barBackgroundColor
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.layer.cornerRadius = 1.0
        searchController.searchBar.clipsToBounds = true
        searchBarView.addSubview(searchController.searchBar)
    }
    
    // MARK: Actions
    
    @IBAction func filterClicked(_ sender: Any) {
        arrowImageView.image = isFilterClicked ? UIImage(named: "arrow_down_flat") : UIImage(named: "arrow_up_flat")
        isFilterClicked = !isFilterClicked
        //performSegue(withIdentifier: "FilterEurekaSegue", sender: self)
        performSegue(withIdentifier: "FilterSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FacetSegue" {
            searchController.isActive = false
            let facetTableViewController = segue.destination as! FacetTableViewController
            facetTableViewController.instantSearchPresenter = InstantSearch.reference
            //facetTableViewController.instantSearch = instantSearch
        }
        
        if segue.identifier == "FilterEurekaSegue" {
            let navigationController = segue.destination as! UINavigationController
            let filterViewController = navigationController.topViewController as! FilterEurekaViewController
            //filterViewController.instantSearch = instantSearch
            
            //TODO: Need to remove this logic once all filters are hooked to InstantSearch since reload will be done automatically behind the scenes.
            filterViewController.didDismiss = {
               // self.instantSearch.searcher.search()
            }
            
        }
        
        if segue.identifier == "FilterSegue" {
            let navigationController = segue.destination as! UINavigationController
            let filterViewController = navigationController.topViewController as! FilterViewController
            filterViewController.instantSearchPresenter = InstantSearch.reference
            filterViewController.didDismiss = {
                //self.instantSearch.searcher.search()
            }
        }
    }
}
