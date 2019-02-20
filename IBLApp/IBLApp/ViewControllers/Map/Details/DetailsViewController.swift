//
//  DetailsViewController.swift
//  IBLApp
//
//  Created by Visar on 2/18/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    var bank: Bank!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Location"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(navigateBack))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        nameLabel.text = bank.name
        addressLabel.text = bank.address
    }
    
    @objc func navigateBack() {
        self.navigationController?.popViewController(animated: true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsTableViewController {
            destination.bank = self.bank
        }
    }
 

}
