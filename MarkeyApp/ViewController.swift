//
//  ViewController.swift
//  MarkeyApp
//
//  Created by Christopher Bankes on 9/28/19.
//  Copyright © 2019 MarkeyCenter. All rights reserved.
//
//Code to set up the search bar, update the search results, and the two relevant Tableviews all originated from: guides.codepath.com/ios/Search-Bar-Guide#using-uisearchcontrollers-ios-8 as a reference
// Default tutorial app is from: https://www.raywenderlich.com/7569-getting-started-with-core-data-tutorial

import UIKit
import CoreData


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var people: [NSManagedObject] = []
    var filteredData: [NSManagedObject]! // Supposed to contain the data pertaining to                                        the search
    
    var stringArray: [String] = []
    
    var searchController: UISearchController!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Patient List:"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate=self
        tableView.dataSource = self
        
        filteredData = people
        
        // searchController should use this view controller to display the results
        // due to serachResultsContoller being nil
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating

        //Setting up the search bar
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.showsScopeBar = true // shows filters to search for
        searchController.searchBar.scopeButtonTitles = ["Name","Age","Illness"] // label of filters
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
    }
    
    
    //  The function that the error was originating from
    //  As far as I can tell it's supposed to take the text from the search bar and put it into searchText, where it then goes through people to filter out only those results to print
        
 /*       func updateSearchResultsForSearchController(searchController: UISearchController) {
           if let searchText = searchController.searchBar.text {
                *********THIS IS WHAT DR. BAKER WAS SHOWING US AFTER CLASS***************
                guard let actualPeople = people as? [Person] else{
                    return
                }
                
                for person in actualPeople{
                    
                    guard let currentPersonsName = person.name else{
                        return
                    }
                    
                    if currentPersonsName.lowercased() == searchText{
                        print("found")
                    }
                }**************************************************
                
                *****THIS IS WHERE THE ERROR IS*********
                filteredData = actualPeople.filter({(dataString: String) -> Bool in
                   return (dataString.lowercased() as AnyObject).containsString(searchText.lowercased())//rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
               })

                
               
                
       //        tableView.reloadData()
        //  }
       // }*/
    
    
    // The following two viewTables are to help the searchbar
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var person = filteredData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")!
        
        if searchController.isActive && searchController.searchBar.text != ""
        {
            person = filteredData[indexPath.row]
        }
        else
        {
            person = people[indexPath.row]
        }
        
        cell.textLabel?.text = person.value(forKeyPath: "TableCell") as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""
        {
        return filteredData.count
        }
        return people.count
    }
    
    //this is from the tutorial. It fetches info from coredata
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Person")
      
      //3
      do {
        people = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }



    // Implement the addName IBAction
    @IBAction func addName(_ sender: UIBarButtonItem) {
      
      let alert = UIAlertController(title: "New Name",
                                    message: "Add a new name",
                                    preferredStyle: .alert)
      
      let saveAction = UIAlertAction(title: "Save", style: .default) {
        [unowned self] action in
        
        guard let textField = alert.textFields?.first,
          let nameToSave = textField.text else {
            return
        }
        
        self.save(name: nameToSave)
        self.tableView.reloadData()
      }

      
      let cancelAction = UIAlertAction(title: "Cancel",
                                       style: .cancel)
      
      alert.addTextField()
      
      alert.addAction(saveAction)
      alert.addAction(cancelAction)
      
      present(alert, animated: true)
    }
    
    //saves info to core data from add function
    func save(name: String) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
    
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "Person",
                                   in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
      person.setValue(name, forKeyPath: "name")
      
      // 4
      do {
        try managedContext.save()
        people.append(person)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }

    

    
}
// from the tutorial, sets up the tableview from ViewController
// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return people.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath)
                 -> UITableViewCell {

    let person = people[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = person.value(forKeyPath: "name") as? String
    return cell
  }
}
//coded this with help from the tutorial linked in patientPage.swift. It allows the switch from the first viewcontroller
//with the entrypoint to the tableViewController which is the patientPage. Also stores the current patient Name for use on the
//openned page
// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patientPC=storyboard?.instantiateViewController(identifier: "patientPage") as! patientPage
        patientPC.patientName=people[indexPath.row]
        navigationController?.pushViewController(patientPC, animated: true)
    }
}

