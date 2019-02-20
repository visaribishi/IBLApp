//
//  WorkHoursViewController.swift
//  IBLApp
//
//  Created by Visar on 2/18/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import UIKit

class WorkHoursViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var workingHours: [WorkingHour] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension WorkHoursViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workingHours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "workHourTableViewCell", for: indexPath)
        let data = self.workingHours[indexPath.row]
        
        cell.textLabel?.text = data.dayName
        cell.detailTextLabel?.text = data.workHours
        
        return cell
    }
}

extension WorkHoursViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
