//
//  RegisterProductChecker.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

struct RegisterProductChecker {
    var completion: (RegisterError) -> Void
    
    func invalidName(textField: UITextField) -> String? {
        guard let name = textField.text,
              (3..<101) ~= name.count else {
            completion(.wrongName)
            return nil
        }
        
        return name
    }
    
    func invalidDescription(textView: UITextView) -> String? {
        guard let description = textView.text,
              (10..<1000) ~= description.count else {
            completion(.wrongDescription)
            return nil
        }
        
        return description
    }
    
    func invalidImage(images: [UIImage?]) {
        let filteredImages = images.compactMap { $0 }
        if filteredImages.count == 0 {
            completion(.wrongImage)
            return
        }
    }
    
    func invalidPrice(textField: UITextField) -> Double? {
        guard let priceText = textField.text,
              let price = Double(priceText) else {
            completion(.wrongPrice)
            return nil
        }
        
        return price
    }
    
    func invalidCurrency(segment: UISegmentedControl) -> Currency? {
        guard let currency = Currency(rawInt: segment.selectedSegmentIndex) else {
            completion(.wrongCurrency)
            return nil
        }
        
        return currency
    }
    
    func invalidDiscountedPrice(textField: UITextField, price: Double) -> Double? {
        let discounted = Double(textField.text ?? "0") ?? 0
        
        guard price > discounted else {
            completion(.wrongDiscount)
            return nil
        }
        
        return discounted
    }
    
}
