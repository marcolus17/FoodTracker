//
//  FoodTrackerViewController.swift
//  FoodTracker
//
//  Created by Nicholas Markworth on 6/22/15.
//  Copyright (c) 2015 Nick Markworth. All rights reserved.
//

import UIKit

class FoodTrackerViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    var searchController: UISearchController!
    var suggestedSearchFood: [String] = []
    var filteredSuggestedSearchFoods: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSearchController()
    }
    
    func setupSearchController() {
        var scopeButtonTitles: [String] = ["Recommended", "Search Results", "Saved"]
        
        // Obtain food array
        self.suggestedSearchFood = Array.suggestedSearchFoods()
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        // Create the search bar in the UI
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles
        // Ensures that the SearchController is presented inside the ViewController
        self.definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if self.searchController.active {
            if self.searchController.searchBar.text.isEmpty {
                return self.suggestedSearchFood.count
            }
            else {
                return self.filteredSuggestedSearchFoods.count
            }
        }
        else {
            return self.suggestedSearchFood.count
        }
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = self.searchController.searchBar.text.lowercaseString
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        
        if searchString == "" {
            filteredSuggestedSearchFoods = suggestedSearchFood
        }
        else {
            self.filterContentForSearch(searchString, scope: selectedScopeButtonIndex)
        }
        
        self.tableView.reloadData()
    }
    
    // Filter the list of results based on what is entered into the search bar
    func filterContentForSearch(searchText: String, scope: Int) {
        self.filteredSuggestedSearchFoods = self.suggestedSearchFood.filter({ (food: String) -> Bool in
            var foodMatch = food.lowercaseString.rangeOfString(searchText)
            return foodMatch != nil
        })
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var foodName: String
        if self.searchController.active {
            if self.searchController.searchBar.text.isEmpty {
                foodName = suggestedSearchFood[indexPath.row]
            }
            else {
                foodName = filteredSuggestedSearchFoods[indexPath.row]
            }
        }
        else {
            foodName = suggestedSearchFood[indexPath.row]
        }

        // Configure the cell...
        cell.textLabel?.text = foodName
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
