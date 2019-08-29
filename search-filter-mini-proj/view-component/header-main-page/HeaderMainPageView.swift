//
//  HeaderMainPageView.swift
//  search-filter-mini-proj
//
//  Created by Macbook on 31/01/19.
//  Copyright © 2019 Timmy. All rights reserved.
//

import UIKit

class HeaderMainPageView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var pageTitleView: UILabel!
    @IBOutlet var backButton: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderMainPage", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
