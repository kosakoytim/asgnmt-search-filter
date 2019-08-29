//
//  Product.swift
//  search-filter-mini-proj
//
//  Created by Macbook on 31/01/19.
//  Copyright © 2019 Timmy. All rights reserved.
//

import Foundation

struct Product {
    let id: Int
    let name: String
    let price: String
    let imageUrl: String
    let condition: Int
    let preorder: Int
    let department_id: Int
}

enum ProductOccasions {
    case all
    case display
}

private protocol SearchDisplay {
    var name: String { get }
    var price: String { get }
    var imageUrl: String { get }
}

extension Product {
    struct Display : SearchDisplay {
        let name: String
        let price: String
        let imageUrl: String
    }
}
