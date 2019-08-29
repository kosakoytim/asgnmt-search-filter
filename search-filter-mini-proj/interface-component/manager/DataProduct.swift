//
//  DataProduct.swift
//  search-filter-mini-proj
//
//  Created by Macbook on 01/02/19.
//  Copyright © 2019 Timmy. All rights reserved.
//

import Foundation
import SwiftHTTP
import SwiftyJSON

final class DataProduct {
    private var products = [Product]()
    private var products_display = [Product.Display]()
    
    private let c = Constants()
    private let t = Tools.shared
    
    init() {}
    
    // GET ==> Products
    func getProducts(query: [[String]],
                     occasions: ProductOccasions,
                     onSuccess: @escaping (Any) -> Void,
                     onFailure: () -> Void) {
        
        let queries = t.constructQuery(queries: query)
        
        HTTP.GET(c.API_TOKOPEDIA + c.LATEST_VERSION_API + c.PRODUCT_ENDPOINT + queries) { response in
            let json = JSON(response.data)
            let data = json["data"]
            var index = 0
            
            switch occasions {
            case .all:
                self.products = []
                for _ in data {
                    let prod = Product(id: json["data"][index]["id"].intValue,
                                       name: json["data"][index]["name"].stringValue,
                                       price: json["data"][index]["price"].stringValue,
                                       imageUrl: json["data"][index]["image_uri"].stringValue,
                                       condition: json["data"][index]["condition"].intValue,
                                       preorder: json["data"][index]["preorder"].intValue,
                                       department_id: json["data"][index]["department_id"].intValue)
                    self.products.append(prod)
                    index = index + 1
                }
                onSuccess(self.products)
            case .display:
                self.products_display = []
                for _ in data {
                    let prod = Product.Display(name: json["data"][index]["name"].stringValue,
                                       price: json["data"][index]["price"].stringValue,
                                       imageUrl: json["data"][index]["image_uri"].stringValue)
                    self.products_display.append(prod)
                    index = index + 1
                }
                onSuccess(self.products_display)
            }
            
            // onFailure()
        }
    }
}
