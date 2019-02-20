//
//  DetailsTableViewController.swift
//  IBLApp
//
//  Created by Visar on 2/18/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController {

    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var workHoursLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!

    var bank: Bank!

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberLabel.text = (bank.phone != nil) ? bank.phone! : "N/A"
        workHoursLabel.text = (bank.workingHours != nil) ? "Opened" : "Closed"
        addressLabel.text = bank.address
        emailLabel.text = bank.email
        websiteLabel.text = bank.website
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && bank.workingHours != nil {
            performSegue(withIdentifier: "goToWorkingHours", sender: bank.workingHours!)
        }
    }
    
    @IBAction func prepareForUnwindToDetails(_ segue: UIStoryboardSegue) {
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WorkHoursViewController {
            // We force unwrap because we know for sure there is data
            destination.workingHours = self.bank.workingHours!
        }
    }
}
