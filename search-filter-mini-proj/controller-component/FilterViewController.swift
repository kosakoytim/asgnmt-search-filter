//
//  FilterViewController.swift
//  search-filter-mini-proj
//
//  Created by Macbook on 31/01/19.
//  Copyright © 2019 Timmy. All rights reserved.
//

import UIKit
import WARangeSlider

class FilterViewController: UIViewController, FilterStateHandler, UITextFieldDelegate {
    var filter_delegate: FilterStateProvider?
    
    @IBOutlet weak var minPrice: UITextField!
    @IBOutlet weak var maxPrice: UITextField!
    @IBOutlet weak var wholesaleSwitch: UISwitch!
    @IBOutlet weak var shopTypeHeaderSection: UIView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var headerHelper: HeaderHelperPageView!

    
    // Current filter state
    private var filter_state = FilterState()
    private var initial_filter_state = FilterState()
    
    // Absolute value
    private let lowest_price_filter: Int = 0
    private let highest_price_filter: Int = 10000000
    private let lowest_slider_val: Double = 0.0
    private let highest_slider_val: Double = 100.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = filter_delegate?.returnFilterState() {
            initial_filter_state = data
            filter_state = data
        }
        setupRangeSlide()
        setupPriceFields()
        setupWholesale()
        setupHeader()
        setupShopTypeSection()
        
        // Register custom shoptype filter cell
        let customProductCell = UINib(nibName: "ShopTypeFilterCell", bundle: nil)
        collView.register(customProductCell, forCellWithReuseIdentifier: "ShopTypeFilterCell")
        collView.reloadData()
    }
    
    private func setupWholesale() {
        wholesaleSwitch.setOn(filter_state.wholesale, animated: true)
    }
    
    private func setupShopTypeSection() {
        shopTypeHeaderSection.addTapGestureRecognizer(action: {
            self.doNavigateTo(target: .shoptype)
        })
    }
    
    private func setupHeader() {
        headerHelper.helperPageTitleText.text = "Filter"
        headerHelper.cancelButton.addTapGestureRecognizer(action: {
            // Reset to initial state (cancel all changes) and navigate to main
            self.filter_state = self.initial_filter_state
            self.doNavigateTo(target: .main)
        })
        headerHelper.resetButton.addTapGestureRecognizer(action: {
            // Reset to tokopedia initial state (cancel all changes)
            self.filter_state = FilterState()
            self.setupRangeSlide()
            self.setupPriceFields()
            self.setupWholesale()
            self.collView.reloadData()
        })
    }
    
    private func setupPriceFields() {
        minPrice.delegate = self
        maxPrice.delegate = self
        minPrice.tag = PriceRange.left.rawValue
        maxPrice.tag = PriceRange.right.rawValue
        // Set value
        minPrice.text = Tools.shared.currencyThis(number: filter_state.lowerPriceRange)
        maxPrice.text = Tools.shared.currencyThis(number: filter_state.upperPriceRange)
    }
    
    private func setupRangeSlide() {
        // Set value
        rangeSlider.minimumValue = lowest_slider_val
        rangeSlider.maximumValue = highest_slider_val
        setSliderValue(slider: .left, value: filter_state.lowerPriceRange.intValue)
        setSliderValue(slider: .right, value: filter_state.upperPriceRange.intValue)
        rangeSlider.addTarget(self, action: #selector(FilterViewController.rangeSliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        setPriceFields(field: .left, value: rangeSlider.lowerValue)
        setPriceFields(field: .right, value: rangeSlider.upperValue)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var number_of_price : String
        func charOnDelete() {
            
        }
        if let priceRange : PriceRange = PriceRange(rawValue: textField.tag) {
            
            switch priceRange {
            case .left:
                number_of_price = filter_state.lowerPriceRange.stringValue
                // if user delete text field char
                if string.count == 0 && range.length > 0 {
                    number_of_price = String(number_of_price.dropLast())
                    if number_of_price.count == 0 {
                        number_of_price = "0"
                    }
                }
                setSliderValue(slider: priceRange, value: Int(number_of_price + string)!)
            case .right:
                number_of_price = filter_state.upperPriceRange.stringValue
                // if user delete text field char
                if string.count == 0 && range.length > 0 {
                    number_of_price = String(number_of_price.dropLast())
                    if number_of_price.count == 0 {
                        number_of_price = "0"
                    }
                }
                setSliderValue(slider: priceRange, value: Int(number_of_price + string)!)
            }
        }
        
        return false
    }
    
    private enum PriceRange : Int {
        case left = 1 //the lower price thumbs / left side
        case right = 2 //the upper price thumbs / right side
    }
    
    // Set slider based on fields
    private func setSliderValue(slider: PriceRange, value: Int) {
        let x = (value * 100) / highest_price_filter
        let z = x as NSNumber
        let y = Double(truncating: z)
        switch slider {
        case .left:
            // dont change any value, if user edited the lower price to higher than upper price
            if value < filter_state.upperPriceRange.intValue {
                rangeSlider.lowerValue = y
                setStateMinPrice(num: value as NSNumber)
                minPrice.text = Tools.shared.currencyThis(number: value as NSNumber)
            }
        case .right:
            // dont change any value, if user edited the upper price to lower than lower price
            if value > filter_state.lowerPriceRange.intValue {
                rangeSlider.upperValue = y
                setStateMaxPrice(num: value as NSNumber)
                maxPrice.text = Tools.shared.currencyThis(number: value as NSNumber)
            }
        }
    }
    
    // Set price fields based on slider
    private func setPriceFields(field: PriceRange, value: Double) {
        let y = Int(value)
        let x = (y * highest_price_filter) / 100
        let z = x as NSNumber
        switch field {
        case .left:
            minPrice.text = Tools.shared.currencyThis(number: z)
            setStateMinPrice(num: z)
        case .right:
            maxPrice.text = Tools.shared.currencyThis(number: z)
            setStateMaxPrice(num: z)
        }
    }
    
    private func setStateMinPrice(num: NSNumber) {
        filter_state.lowerPriceRange = num
    }
    
    private func setStateMaxPrice(num: NSNumber) {
        filter_state.upperPriceRange = num
    }
    
    @IBAction func applyFilterButton(_ sender: UIButton) {
        self.doNavigateTo(target: .main)
    }
    
    @IBAction func switchWholesale(_ sender: Any) {
        filter_state.wholesale = !filter_state.wholesale
        setupWholesale()
    }
    
    private enum AvailableNavigateTarget {
        case main
        case shoptype
    }
    
    private func doNavigateTo(target: AvailableNavigateTarget) {
        switch target {
        case .main:
            performSegue(withIdentifier: "FilterToMain", sender: nil)
        case .shoptype:
            performSegue(withIdentifier: "FilterToShoptype", sender: nil)
        }
    }
    
}

extension FilterViewController : FilterStateProvider {
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

extension FilterViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func getShopTypeActive() -> [[Shoptypes:Bool]] {
        var all_data: [[Shoptypes:Bool]] = []
        let data_values = Array(filter_state.shopTypes.values)
        let data_keys = Array(filter_state.shopTypes.keys)
        var index = 0
        for shop_type_active in data_values {
            if shop_type_active {
                all_data.append([data_keys[index] : data_values[index]])
            }
            index = index + 1
        }
        
        return all_data
    }
    
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
        let data = getShopTypeActive()[index]
        let data_keys_name = Array(data.keys)[0].rawValue
        return data_keys_name
    }
    
    func getShopTypeKey(index: Int) -> Shoptypes {
        let data = getShopTypeActive()[index]
        let data_keys = Array(data.keys)[0]
        return data_keys
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getShopTypeActive().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopTypeFilterCell", for: indexPath) as! ShopTypeFilterCell
        // Bind the data here
        cell.shopTypeLabel.text = getShopTypeName(index: indexPath.row)
        cell.shopTypeLabel.addTapGestureRecognizer(action: {
            self.removeShoptypes(type: self.getShopTypeKey(index: indexPath.row))
        })
        cell.deleteShopType.addTapGestureRecognizer(action: {
            self.removeShoptypes(type: self.getShopTypeKey(index: indexPath.row))
        })
        return cell
    }
    
    private func removeShoptypes(type : Shoptypes) {
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

        // Calculate label character length to get cell width
        let width_label: CGFloat = CGFloat(getShopTypeName(index: indexPath.row).count) * 10
        return CGSize(width: width_label, height: 70)
    }
    
    
}


