//
//  OrderDetailViewController.swift
//  ResturantAPI
//
//  Created by Everett Brothers on 10/24/23.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var prepLabel: UILabel!
    
    var minsToPrepare: Int = 0
    var formattedTotal: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuIds = MenuController.shared.order.menuItems.map { $0.id }
        Task {
            do {
                let minsToPrepareOrder = try await MenuController.shared.submitOrder(forIds: menuIds)
                self.minsToPrepare = minsToPrepareOrder
                let orderTotal = MenuController.shared.order.menuItems.reduce(0.0) { (result, menuItem) -> Double in
                    return result + menuItem.price
                }
                formattedTotal = orderTotal.formatted(.currency(code: "usd"))
                
                prepLabel.text = "Your order total is: \(formattedTotal), and will take \(minsToPrepare) minutes to prepare."
            } catch {
                print("OrderDetailViewController: line 28. \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func payTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Pay", message: "Total: \(formattedTotal)\nPrep Time: \(minsToPrepare) mins", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Pay", style: .default) { _ in
            MenuController.shared.order.menuItems = []
            self.performSegue(withIdentifier: "toOrders", sender: nil)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
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
