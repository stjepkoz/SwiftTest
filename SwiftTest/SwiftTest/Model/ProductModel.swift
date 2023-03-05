//
//  ProductModel.swift
//  SwiftTest
//
//  Created by Stjepko Zrncic on 26/02/23.
//

import Foundation

struct Product: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let brand: String
    let category: String
    let thumbnail: URL
}

struct Products: Codable {
    let products: [Product]
}

struct ProductModelMock {
    
    static let dummy = Product(id: 124543, title: "test", description: "test", price: 10.00, discountPercentage: 0.00, rating: 5.0, brand: "test brand", category: "test category", thumbnail: URL(string: "http://google.com")!)
}
