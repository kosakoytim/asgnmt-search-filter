//
//  FilterState.swift
//  search-filter-mini-proj
//
//  Created by Macbook on 03/02/19.
//  Copyright © 2019 Timmy. All rights reserved.
//

import Foundation

struct FilterState {
    var lowerPriceRange: NSNumber = 0
    var upperPriceRange: NSNumber = 8000000
    var wholesale: Bool = false
    var shopTypes: [Shoptypes:Bool] = [.goldMerchant: true, .officialStore: true]
}

enum Shoptypes : String {
    case goldMerchant = "Gold Merchant"
    case officialStore = "Official Store"
}

protocol FilterStateProvider: class {
    func returnFilterState() -> FilterState?
}

protocol FilterStateHandler: class {
    var filter_delegate: FilterStateProvider? {get set}
}
