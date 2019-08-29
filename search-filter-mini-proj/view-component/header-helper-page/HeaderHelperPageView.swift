//
//  HeaderHelperPageView.swift
//  search-filter-mini-proj
//
//  Created by Macbook on 31/01/19.
//  Copyright © 2019 Timmy. All rights reserved.
//

import UIKit

class HeaderHelperPageView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var cancelButton: UIImageView!
    @IBOutlet weak var helperPageTitleText: UILabel!
    @IBOutlet var resetButton: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderHelperPage", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }


}
