//
//  ViewController.swift
//  MarkeyApp
//
//  Created by Christopher Bankes on 9/28/19.
//  Copyright © 2019 MarkeyCenter. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var people: [NSManagedObject] = []
    
    var filteredData: [NSManagedObject]! // Supposed to contain the data pertaining to the search?
    
    var stringArray: [String] = []
    
    var searchController: UISearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Patient List:"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate=self
        tableView.dataSource = self
        
        filteredData = people
        
        //Just stuff to make the Search Bar
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false

        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
    }
    
    
    //  The function that the error was originating from
    //  As far as I can tell it's supposed to take the text from the search bar and put it into searchText, where it then goes through people to filter out only those results to print
        
    ///    func updateSearchResultsForSearchController(searchController: UISearchController) {
    ///        if let searchText = searchController.searchBar.text {
    ///            filteredData = people.filter({(dataString: String) -> Bool in
    ///               return (dataString.localizedLowercase as AnyObject).containsString(searchText.lowercased())//rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
    ///           })

                
               
                
    ///           tableView.reloadData()
    ///        }
    ///    }
    
    
    // I believe I modified these two tableViews
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
    let cell =
      tableView.dequeueReusableCell(withIdentifier: "Cell",
                                    for: indexPath)
    cell.textLabel?.text = person.value(forKeyPath: "name") as? String
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patientPC=storyboard?.instantiateViewController(identifier: "patientPage") as! patientPage
        patientPC.patientName=people[indexPath.row]
        navigationController?.pushViewController(patientPC, animated: true)
    }
}

