//
//  ItemsTableViewController.swift
//  ResturantAPI
//
//  Created by Everett Brothers on 10/24/23.
//

import UIKit

@MainActor
class ItemsTableViewController: UITableViewController {

    var category: String
    var items: [MenuItem] = []
    
    init?(coder: NSCoder, catergory: String) {
        self.category = catergory
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBSegueAction func toDetail(_ coder: NSCoder, sender: Any?) -> ItemDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        return ItemDetailViewController(coder: coder, item: items[indexPath.row])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = category.capitalized
        
        Task {
            do {
                let items = try await MenuController.shared.fetchMenuItems(for: category)
                updateUi(for: items)
            } catch {
                print("ItemsTableViewController: line 33. \(error.localizedDescription)")
            }
        }
    }
    
    func updateUi(for items: [MenuItem]) {
        self.items = items
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        configure(cell, for: indexPath)
        
        return cell
    }
    
    func configure(_ cell: UITableViewCell, for indexPath: IndexPath) {
        let item = items[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = item.name
        content.secondaryText = item.price.formatted(.currency(code: "usd"))
        cell.contentConfiguration = content
    }
}
