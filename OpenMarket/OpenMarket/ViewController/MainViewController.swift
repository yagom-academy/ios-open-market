//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit


final class MainViewController: UIViewController {
    @IBOutlet weak var segmentSwitch: UISegmentedControl!
    @IBOutlet weak var collectionListView: UIView!
    @IBOutlet weak var collectionGridView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSegmentSwitch()
    }
    
    @IBAction private func switchView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            collectionListView.alpha = 1
            collectionGridView.alpha = 0
        case 1:
            collectionListView.alpha = 0
            collectionGridView.alpha = 1
        default:
            break
        }
    }
    
    @IBAction private func switchAddProductView(_ sender: UIButton) {
        guard let addProductViewController = self.storyboard?.instantiateViewController(withIdentifier: "addProductViewController") as? AddProductViewController else { return }
        addProductViewController.modalTransitionStyle = .coverVertical
        addProductViewController.modalPresentationStyle = .fullScreen
                self.present(addProductViewController, animated: true, completion: nil)
    }
    
    private func setSegmentSwitch() {
        segmentSwitch.selectedSegmentTintColor = .systemBlue
        segmentSwitch.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentSwitch.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        segmentSwitch.layer.borderWidth = 1
        segmentSwitch.layer.borderColor = UIColor.systemBlue.cgColor
    }
}

