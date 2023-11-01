//
//  MenuController.swift
//  ResturantAPI
//
//  Created by Everett Brothers on 10/24/23.
//

import Foundation

class MenuController {
    enum MenuControllerError: Error, LocalizedError {
        case catergoriesNotFound
        case menuItemsNotFound
        case orderRequestFailed
    }
    
    static let shared = MenuController()
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderNotification, object: nil)
        }
    }
    
    static let orderNotification = Notification.Name("MenuController.orderUpdated")
    
    typealias MinutesToPrepare = Int
    
    let baseURL = URL(string: "http://localhost:8080/")!
    
    func fetchCatergories() async throws -> [String] {
        let catergoriesURL = baseURL.appendingPathComponent("categories")
        let (data, response) = try await URLSession.shared.data(from: catergoriesURL)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MenuControllerError.catergoriesNotFound
        }
        let decoder = JSONDecoder()
        let catergoriesResponse = try decoder.decode(CategoriesResponse.self, from: data)
        
        return catergoriesResponse.categories
    }
    
    func fetchMenuItems(for catergoryName: String) async throws -> [MenuItem] {
        let baseMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: catergoryName)]
        let menuURL = components.url!
        let (data, response) = try await URLSession.shared.data(from: menuURL)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MenuControllerError.menuItemsNotFound
        }
        let decoder = JSONDecoder()
        let menuResponse = try decoder.decode(MenuResponse.self, from: data)
        
        return menuResponse.items
    }
    
    func submitOrder(forIds ids: [Int]) async throws -> MinutesToPrepare {
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let menuIdsDict = ["menuIds": ids]
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(menuIdsDict)
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MenuControllerError.orderRequestFailed
        }
        let decoder = JSONDecoder()
        let orderResponse = try decoder.decode(OrderResponse.self, from: data)
        
        return orderResponse.prepTime
    }
}
