// Logan Manns
//  patientPage.swift
//  MarkeyApp
//
//  Created by Logan Manns on 10/2/19.
//  Copyright © 2019 MarkeyCenter. All rights reserved.
// Reference: https://www.youtube.com/watch?v=Q_IktHZGzi4&list=WL&index=59&t=0s
// Used to help set the delegate to get to this tableView and to set up the menuCellLabel

import Foundation
import UIKit
import CoreData
class patientPage : UITableViewController
{
    var patientName : NSManagedObject?
    var patientLabelPlate :String?
    
    @IBOutlet var PatientInfoTable: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title=patientName!.value(forKeyPath: "name") as? String
        self.PatientInfoTable.register(menuCell.self, forCellReuseIdentifier: "Cell")

        PatientInfoTable.dataSource=self
        PatientInfoTable.delegate=self
    }
    override func tableView(_ PatientInfoTable: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuOptions.count
    }
    let menuOptions=["Basic Patient Information"]
    override func tableView(_ PatientInfoTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let menuCellActual = PatientInfoTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) //as! menuCell
        let anotherLabel=menuOptions[indexPath.row]
        
      //  menuCellActual.menuCellLabel.text=anotherLabel
        return menuCellActual
    }
}
