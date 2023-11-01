//
//  Order.swift
//  ResturantAPI
//
//  Created by Everett Brothers on 10/24/23.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
