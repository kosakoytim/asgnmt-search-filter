//
//  ShopTypeViewController.swift
//  search-filter-mini-proj
//
//  Created by Macbook on 31/01/19.
//  Copyright © 2019 Timmy. All rights reserved.
//

import UIKit

class ShopTypeViewController: UIViewController, FilterStateHandler {
    var filter_delegate: FilterStateProvider?
    
    @IBOutlet weak var headerHelper: HeaderHelperPageView!
    @IBOutlet weak var collView: UICollectionView!
    
    
    private var filter_state = FilterState()
    private var initial_filter_state = FilterState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = filter_delegate?.returnFilterState() {
            initial_filter_state = data
            filter_state = data
        }
        
        setupHeader()
        
        // Register custom shoptype cell
        let customProductCell = UINib(nibName: "ShopTypeCell", bundle: nil)
        collView.register(customProductCell, forCellWithReuseIdentifier: "ShopTypeCell")
        collView.reloadData()
    }
    
    @IBAction func applyButton(_ sender: Any) {
        performSegue(withIdentifier: "ShoptypeToFilter", sender: nil)
    }
    
    private func setupHeader() {
        headerHelper.helperPageTitleText.text = "Shop Type"
        headerHelper.cancelButton.addTapGestureRecognizer(action: {
            // Reset to initial state (cancel all changes)
            self.filter_state = self.initial_filter_state
            self.performSegue(withIdentifier: "ShoptypeToFilter", sender: nil)
        })
        headerHelper.resetButton.addTapGestureRecognizer(action: {
            // Reset to tokopedia initial state (cancel all changes)
            self.filter_state.shopTypes = FilterState().shopTypes
            self.collView.reloadData()
        })
    }
}

extension ShopTypeViewController : FilterStateProvider {
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

extension ShopTypeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func getShopTypeAll() -> [[Shoptypes:Bool]] {
        var all_data: [[Shoptypes:Bool]] = []
        let data_values = Array(filter_state.shopTypes.values)
        let data_keys = Array(filter_state.shopTypes.keys)
        var index = 0
        for _ in data_values {
            all_data.append([data_keys[index] : data_values[index]])
            index = index + 1
        }
        
        return all_data
    }
    
    func getShopTypeName(index : Int) -> String {
        let data = getShopTypeAll()[index]
        let data_keys = Array(data.keys)[0].rawValue
        return data_keys
    }
    
    func getShopTypeKey(index : Int) -> Shoptypes {
        let data = getShopTypeAll()[index]
        let data_keys = Array(data.keys)[0]
        return data_keys
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getShopTypeAll().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopTypeCell", for: indexPath) as! ShopTypeCell
        // Bind the data here
        cell.shopTypeLabel.text = getShopTypeName(index: indexPath.row)
        let data_values = Array(filter_state.shopTypes.values)
        cell.shopTypeSwitch.setOn(data_values[indexPath.row], animated: true)
        cell.shopTypeSwitch.tag = indexPath.row
        cell.shopTypeSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        return cell
    }
    
    @objc private func switchChanged(_ sender : UISwitch!){
        toggleShoptypes(type: self.getShopTypeKey(index: sender.tag))
    }
    
    private func toggleShoptypes(type: Shoptypes) {
        var final_data = [Shoptypes:Bool]()
        let all_shop_types = getShopTypeAll()
        
        for item in all_shop_types {
            if type == Array(item.keys)[0] {
                final_data[Array(item.keys)[0]] = !Array(item.values)[0]
            } else {
                final_data[Array(item.keys)[0]] = Array(item.values)[0]
            }
        }
        
        filter_state.shopTypes = final_data
        collView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopTypeCell", for: indexPath) as! ShopTypeCell
        let width : CGFloat = UIScreen.main.bounds.width
        let height : CGFloat = cell.shopTypeSwitch.frame.height + 40
        return CGSize(width: width, height: height)
    }
}

