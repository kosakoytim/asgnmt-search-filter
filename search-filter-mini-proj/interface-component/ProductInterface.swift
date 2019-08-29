//
//  ProductInterface.swift
//  search-filter-mini-proj
//
//  Created by Macbook on 31/01/19.
//  Copyright © 2019 Timmy. All rights reserved.
//

import Foundation


// Center interface for product, this class will interact directly to other classes that manage HTTP request and others
// Will be more useful later when product functionality gets complex

final class ProductInterface {
    static let shared = ProductInterface()
    private let dataProduct = DataProduct()
    private init () {}
    
    func getProducts(query: [[String]], occasions: ProductOccasions ,onSuccess: @escaping (Any) -> Void, onFailure: () -> Void) {
        dataProduct.getProducts(query: query, occasions: occasions, onSuccess: { products in
            onSuccess(products)
        }, onFailure: {
            // Do exception task here
        })
    }
    
    
}
