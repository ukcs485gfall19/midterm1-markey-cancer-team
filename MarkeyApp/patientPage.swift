//
//  patientPage.swift
//  MarkeyApp
//
//  Created by Logan Manns on 10/2/19.
//  Copyright © 2019 MarkeyCenter. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class patientPage : UITableViewController {
    var patientName : NSManagedObject?
    var patientLabelPlate :String?
    
    @IBOutlet var PatientInfoTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title=patientName!.value(forKeyPath: "name") as? String
        PatientInfoTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        PatientInfoTable.dataSource=self
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = PatientInfoTable.dequeueReusableCell(withIdentifier: "Cell")!
        return cell
    }
}
