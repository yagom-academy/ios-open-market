//
//  MainViewController.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/02/05.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getItemList(page: page)
    }
    
    private func getItemList(page: Int) {
        NetworkLayer.shared.requestItemList(page: page) { result in
            switch result {
            case .success(let itemList):
                self.itemList.append(itemList)
                DispatchQueue.main.async {
                    self.listViewController.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupView() {
        
    }
    
    @IBAction func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: gridViewController)
            add(asChildViewController: listViewController)
        } else {
            remove(asChildViewController: listViewController)
            add(asChildViewController: gridViewController)
        }
    }
}
