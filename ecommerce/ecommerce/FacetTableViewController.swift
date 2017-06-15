//
//  FacetTableViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 07/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import InstantSearch
import UIKit

class FacetTableViewController: UIViewController, RefinementTableViewDataSource {
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var topBarView: TopBarView!
    @IBOutlet weak var nbHitsLabel: UILabel!
    @IBOutlet weak var tableView: RefinementTableWidget!
    
    var refinementController: RefinementController!
    
    var searchController: UISearchController!
    let FACET_NAME = "category"
//    var instantSearch: InstantSearch!
    var instantSearchPresenter: InstantSearch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refinementController = RefinementController(table: tableView)
        tableView.dataSource = refinementController
        tableView.delegate = refinementController
        refinementController.tableDataSource = self

        instantSearchPresenter.registerAllWidgets(in: self.view)
//        categoryFacets = instantSearch.getSearchFacetRecords(withFacetName: FACET_NAME)!
//        
//        instantSearch.addWidget(stats: nbHitsLabel)
        configureNavBar()
        topBarView.backgroundColor = ColorConstants.tableColor
        configureSearchController()
        configureTable()
//        instantSearch.set(facetSearchController: searchController)
//        instantSearch.facetDataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchController.isActive = false
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool)  -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath) as! FacetCategoryCell
        cell.facet = facet
        cell.count = count
        cell.isRefined = refined
        cell.backgroundColor = ColorConstants.tableColor
        
        return cell
    }
    
    func configureTable() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.backgroundColor = ColorConstants.tableColor
    }
    
    func configureNavBar() {
        navigationController?.navigationBar.barTintColor = ColorConstants.barBackgroundColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : ColorConstants.barTextColor]
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search categories"
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.barTintColor = ColorConstants.barBackgroundColor
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.layer.cornerRadius = 1.0
        searchController.searchBar.clipsToBounds = true
        searchBarView.addSubview(searchController.searchBar)
    }
    
    deinit {
        self.searchController?.view.removeFromSuperview()
    }
}
