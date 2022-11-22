//
//  OpenMarket - ProductListViewController.swift
//  Created by Aejong, Tottale on 2022/11/22.
// 

import UIKit

class ProductListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureSegmentedControl()
        configureNavigationBar()
        configureAddButton()
    }
    
    @objc private func addButtonPressed() {
        let addProductViewController = AddProductViewController()
        self.present(addProductViewController, animated: true, completion: nil)
    }
}

extension ProductListViewController {
    private func configureNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func configureSegmentedControl() {
        let segmentTextContent = [NSLocalizedString("LIST", comment: ""), NSLocalizedString("GRID", comment: "")]
        let segmentedControl = UISegmentedControl(items: segmentTextContent)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
        
        self.navigationItem.titleView = segmentedControl
    }
    
    private func configureAddButton() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = addItem
    }
}
