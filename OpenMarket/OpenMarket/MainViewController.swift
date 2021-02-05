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
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var listView: UIView!
    private var listViewController: ItemListViewController?
    private var gridViewController: ItemGridViewController?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        getItemList(page: page)
    }
    
    private func setupView() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        listViewController = children[1] as? ItemListViewController
        gridViewController = children[0] as? ItemGridViewController
    }
    
    private func getItemList(page: Int) {
        NetworkLayer.shared.requestItemList(page: page) { result in
            switch result {
            case .success(let itemList):
                ItemListModel.shared.data.append(contentsOf: itemList.items)
                DispatchQueue.main.async { [weak self] in
                    guard let listViewController = self?.listViewController,
                          let gridViewController = self?.gridViewController else { fatalError() }
                    listViewController.tableView.reloadData()
                    gridViewController.collectionView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            listView.isHidden = false
            gridView.isHidden = true
        } else {
            listView.isHidden = true
            gridView.isHidden = false
        }
    }
}
