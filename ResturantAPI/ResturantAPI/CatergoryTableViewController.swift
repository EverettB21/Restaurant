//
//  CatergoryTableViewController.swift
//  ResturantAPI
//
//  Created by Everett Brothers on 10/24/23.
//

import UIKit

@MainActor
class CatergoryTableViewController: UITableViewController {

    var catergories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            do {
                let catergories = try await MenuController.shared.fetchCatergories()
                updateUi(with: catergories)
            } catch {
                print("CatergoryTableViewController: Line 24. \(error.localizedDescription)")
            }
        }
    }
    
    func updateUi(with catergories: [String]) {
        self.catergories = catergories
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catergories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catergory", for: indexPath)
        configure(cell, for: indexPath)
        
        return cell
    }
    
    func configure(_ cell: UITableViewCell, for indexPath: IndexPath) {
        let catergory = catergories[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = catergory.capitalized
        cell.contentConfiguration = content
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toMenu", sender: tableView.cellForRow(at: indexPath))
    }
    
    @IBSegueAction func toMenu(_ coder: NSCoder, sender: Any?) -> ItemsTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }
        let vc = ItemsTableViewController(coder: coder, catergory: catergories[indexPath.row])
        return vc
    }
    
}
