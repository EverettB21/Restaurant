//
//  ItemDetailViewController.swift
//  ResturantAPI
//
//  Created by Everett Brothers on 10/24/23.
//

import UIKit

class ItemDetailViewController: UIViewController {

    var item: MenuItem
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    init?(coder: NSCoder, item: MenuItem) {
        self.item = item
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = item.name.capitalized
        
        imageView.layer.cornerRadius = 20
        nameLabel.text = item.name.capitalized
        priceLabel.text = item.price.formatted(.currency(code: "usd"))
        detailLabel.text = item.detailText
        
        if let url = URL(string: item.imageURL) {
            Task {
                do {
                    let (data, response) = try await URLSession.shared.data(from: url)
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        print("failed to load image")
                        return
                    }
                    imageView.image = UIImage(data: data)
                } catch {
                    print("failed to load url \(error.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func addToOrder(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: [], animations: {
            self.addButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.addButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        MenuController.shared.order.menuItems.insert(item, at: 0)
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
