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
    
    func setuplabel(){
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title=patientName!.value(forKeyPath: "name") as? String
    }
}
