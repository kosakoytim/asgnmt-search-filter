//
//  ViewController.swift
//  search-filter-mini-proj
//
//  Created by Macbook on 30/01/19.
//  Copyright © 2019 Timmy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FilterStateHandler {
    var filter_delegate: FilterStateProvider?
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet var headerBar: HeaderMainPageView!
    
    private enum Constants {
        static let CellIdentifier = "Cell"
    }
    private var products = [Product.Display]()
    private var filter_state = FilterState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set header title
        headerBar.pageTitleView.text = "Search"
        
        // If there are filter state passed, do this, else use default filter state
        if let data = filter_delegate?.returnFilterState() {
            filter_state = data
        }
        
        initiateDataGetter()
        
        // Register custom product cell
        let customProductCell = UINib(nibName: "MainItemCell", bundle: nil)
        collView.register(customProductCell, forCellWithReuseIdentifier: "MainItemCell")
        collView.reloadData()
    }
    
    private func initiateDataGetter() {
        products = []
        collView.reloadData()
        
        var final_queries: [[String]] = [
            ["q","samsung"], // hardcoded
            ["pmin",String(filter_state.lowerPriceRange.intValue)],
            ["pmax",String(filter_state.upperPriceRange.intValue)],
            ["wholesale",String(filter_state.wholesale)],
            ["start",String(0)],
            ["rows",String(10)]
        ]
        
        if (filter_state.shopTypes[.officialStore]!) {
            final_queries.append(["official","true"])
        } else {
            final_queries.append(["official","false"])
        }
        
        if (filter_state.shopTypes[.goldMerchant]!) {
            final_queries.append(["fshop","2"])
        }
        
        // Get the search data
        ProductInterface.shared.getProducts(query: final_queries, occasions: .display, onSuccess: { products in
            DispatchQueue.main.async {
                self.products = products as! [Product.Display]
                self.collView.reloadData()
            }
        }, onFailure: {
            print("Error")
        })
    }
    
    @IBAction func addFilterButton(_ sender: Any) {
        performSegue(withIdentifier: "MainToFilter", sender: nil)
    }
}

extension ViewController : FilterStateProvider {
    func returnFilterState() -> FilterState? {
        return filter_state
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? FilterStateHandler {
            destination.filter_delegate = self
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainItemCell", for: indexPath) as! MainItemCell
        // Bind the data here
        let data = products[indexPath.row]
        cell.productTitle?.text = data.name
        cell.productPrice?.text = data.price
        cell.productImage?.image = Tools.shared.downloadImage(data.imageUrl)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Set some kind of margin of the cell
        let inset: CGFloat = 5
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Set the padding between collection view items
        let padding_width: CGFloat =  20
        
        // Get image, and text height to calculate row height
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainItemCell", for: indexPath) as! MainItemCell
        let height_image: CGFloat = (UIScreen.main.bounds.width - padding_width)/2 + 20
        let height_text_name: CGFloat = cell.productTitle!.frame.height
        let height_text_price: CGFloat = cell.productPrice!.frame.height
        let calculate_height: CGFloat = height_image + height_text_name + height_text_price
        
        // Programmatically make the collection view in 2 columns layout 50:50, and set the calculated row height
        return CGSize(width: (UIScreen.main.bounds.width - padding_width)/2, height: calculate_height)
        
    }
}


