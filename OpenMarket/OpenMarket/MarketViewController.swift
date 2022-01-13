//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
// 🤞
final class MarketViewController: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    
    private let apiService = MarketAPIService()
    private var products: [Product] = []
    
    private lazy var listViewController: ListViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "ListViewController") { coder in
            ListViewController(products: self.products, coder: coder)
        }
        return viewController
    }()
    
    private lazy var gridViewController: GridViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "GridViewController") { coder in
            GridViewController(products: self.products, coder: coder)
        }
        return viewController
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.isHidden = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loadingIndicator)
        
        let horizontalConstraint = loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let verticalConstraint = loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        
        self.view.addConstraint(horizontalConstraint)
        self.view.addConstraint(verticalConstraint)
        
        return loadingIndicator
    }()
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedControl()
        fetchPage()
    }
}

//MARK: - IBActions

extension MarketViewController {
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            remove(asChildViewController: gridViewController)
            add(asChildViewController: listViewController)
        } else {
            remove(asChildViewController: listViewController)
            add(asChildViewController: gridViewController)
        }
    }
}

//MARK: - Private Methods

extension MarketViewController {
    private func startLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    private func stopLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
    
    private func showListViewController() {
        DispatchQueue.main.async {
            self.add(asChildViewController: self.listViewController)
        }
    }
    
    private func setupSegmentedControl() {
        segmentedControl.setTitle("LIST", forSegmentAt: 0)
        segmentedControl.setTitle("GRID", forSegmentAt: 1)
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.backgroundColor = .white
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func fetchPage() {
        startLoadingIndicator()
        apiService.fetchPage(pageNumber: 1, itemsPerPage: 20) { [weak self] result in
            self?.stopLoadingIndicator()
            switch result {
            case .success(let data):
                self?.products = data.products
                self?.showListViewController()
            case .failure(let error):
                print(error)
            }
        }
    }
}

