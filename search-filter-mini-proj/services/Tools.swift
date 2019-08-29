//
//  Tools.swift
//  search-filter-mini-proj
//
//  Created by Macbook on 01/02/19.
//  Copyright © 2019 Timmy. All rights reserved.
//

import Foundation
import UIKit

final class Tools {
    
    static let shared = Tools()
    
    private init(){}
    
    // to download image
    func downloadImage(_ url: String) -> UIImage? {
        let aUrl = URL(string: url)
        guard let data = try? Data(contentsOf: aUrl!),
            let image = UIImage(data: data) else {
                return nil
        }
        return image
    }
    
    // to generate query for APIs fron [String] types
    func constructQuery(queries: Array<[String]>) -> String {
        var final_query = "?"
        var index = 0
        for query in queries {
            if (index == 0) {
                final_query = final_query + query[0] + "=" + query[1]
            } else {
                final_query = final_query + "&" + query[0] + "=" + query[1]
            }
            index = index + 1
        }
        return final_query
    }
    
    // to format into currency Rupiah
    func currencyThis(number: NSNumber) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "id_ID")
        let price = currencyFormatter.string(from: number)
        return price!
    }
}

