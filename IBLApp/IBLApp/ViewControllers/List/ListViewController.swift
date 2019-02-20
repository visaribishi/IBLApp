//
//  ListViewController.swift
//  IBLApp
//
//  Created by Visar on 2/18/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import UIKit

private enum State {
    case loading
    case populated(bankList: [Bank], searchFilterClosure: (Bank) -> Bool)
    case empty
    case error(Error)
    
    var items: [Bank] {
        guard case let .populated(bankList, searchFilterClosure) = self else {
            return []
        }
        return bankList.filter(searchFilterClosure)
    }
}

class ListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var state = State.loading {
        didSet {
            updateViewFromState()
            tableView.reloadData()
        }
    }
    
    private lazy var searchFilterClosure = { [weak self] (bank: Bank) -> Bool in
        guard let `self` = self else { return false }
        guard let searchText = self.searchBar.text, !searchText.isEmpty else {
            return true
        }
        // split to words
        let searchTerms = searchText.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        guard !searchTerms.isEmpty else {
            return true
        }
        // Iterate over all terms with AND logic
        for searchTerm in searchTerms.filter({ !$0.isEmpty }) {
            // Concatenate different attributes of Bank object to make one string to search
            let stringToCompare = [
                bank.name,
                bank.address
                ].compactMap({ $0 }).joined(separator: " ")
            if stringToCompare.range(of: searchTerm, options: [.diacriticInsensitive, .caseInsensitive]) == nil {
                // At least one seach term has not been found in any of the attributes
                return false
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        getBankList()
    }
    
    func getBankList() {
        state = .loading
        DataManager.shared.getBankList { (result) in
            switch result {
            case .success(let banks):
                self.state = .populated(bankList: banks, searchFilterClosure: self.searchFilterClosure)
            case .failure(let error):
                self.state = .error(error)
            }
        }
    }
    
    func focusSelectedBank(with location: Location) {
        if let parent = parent as? ViewController {
            parent.switchToMap()
            parent.focus(location: location)
        }
    }
    
    private func updateViewFromState() {
        switch state {
        case .loading:
            // Add loading indicator
            break
        case .empty, .error:
            // Display empty/error views
            break
        case .populated:
            // Dismiss loading indicator
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.state.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        let bank = self.state.items[indexPath.row]
        cell.nameLabel.text = bank.name
        cell.addressLabel.text = bank.address
        switch bank.type {
        case .branch:
            cell.typeImageView.image = UIImage(named: "ic_branch")
        case .atm:
            cell.typeImageView.image = UIImage(named: "ic_atm")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bank = self.state.items[indexPath.row]
        self.focusSelectedBank(with: bank.location)
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: - UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard case let .populated(entries, _) = self.state else {
            return
        }
        self.state = .populated(bankList: entries, searchFilterClosure: self.searchFilterClosure)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
