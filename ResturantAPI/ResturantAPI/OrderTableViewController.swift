//
//  OrderTableViewController.swift
//  ResturantAPI
//
//  Created by Everett Brothers on 10/24/23.
//

import UIKit

class OrderTableViewController: UITableViewController {

    var order = Order()
    var minsToPrepare: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateButton()
    }
    
    func updateButton() {
        if MenuController.shared.order.menuItems.count > 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(submit))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func submit() {
        performSegue(withIdentifier: "toOrderDetail", sender: nil)
    }
    
    @IBAction func unwindToOrders(segue: UIStoryboardSegue) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for: indexPath)
        configure(cell, for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
            updateButton()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? OrderDetailViewController {
            vc.minsToPrepare = minsToPrepare
        }
    }
    
    func configure(_ cell: UITableViewCell, for indexPath: IndexPath) {
        let item = MenuController.shared.order.menuItems[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = item.name
        content.secondaryText = item.price.formatted(.currency(code: "usd"))
        cell.contentConfiguration = content
    }
}
