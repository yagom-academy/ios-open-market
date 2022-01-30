//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MarketViewController: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    
    private var products: [Product] = []
    
    private lazy var listViewController: ListViewController = {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.main, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(
            identifier: ListViewController.identifier
        ) { coder in
            ListViewController(products: self.products, coder: coder)
        }
        return viewController
    }()
    
    private lazy var gridViewController: GridViewController = {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.main, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(
            identifier: GridViewController.identifier
        ) { coder in
            GridViewController(products: self.products, coder: coder)
        }
        return viewController
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.isHidden = false

        self.view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        return loadingIndicator
    }()
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObserver()
        setupSegmentedControl()
        fetchPage(pageNumber: 1, itemsPerPage: 20) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.showListViewController()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(Notification.Name.productUpdated)
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
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard let destination = storyboard?.instantiateViewController(
            identifier: ProductFormViewController.identifier,
            creator: { coder in
                ProductFormViewController(delegate: self, pageMode: .register, coder: coder)
            }
        ) else {
            assertionFailure("init(coder:) has not been implemented")
            return
        }
        
        destination.modalPresentationStyle = .fullScreen
        present(destination, animated: true, completion: nil)
    }
}

//MARK: - Private Methods

extension MarketViewController {
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleProductUpdatedNotification),
            name: Notification.Name.productUpdated,
            object: nil
        )
    }
    
    @objc private func handleProductUpdatedNotification(_ notification: Notification) {
        guard let isUpdated = notification.userInfo? ["isUpdated"] as? Bool else {
            return
        }
        if isUpdated {
            reloadCollectionViews()
        }
    }
    
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
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
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
    
    private func fetchPage(
        pageNumber: Int,
        itemsPerPage: Int,
        completion: @escaping (_ products: [Product]?) -> ()
    ) {
        let apiService = MarketAPIService()
        apiService.fetchPage(
            pageNumber: pageNumber,
            itemsPerPage: itemsPerPage
        ) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                self.products = data.products
                completion(data.products)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func reloadCollectionViews() {
        startLoadingIndicator()
        fetchPage(pageNumber: 1, itemsPerPage: 20) { [weak self] products in
            guard let products = products,
                  let self = self else {
                return
            }
            self.stopLoadingIndicator()
            self.listViewController.reloadCollectionView(with: products)
            DispatchQueue.main.async {
                self.gridViewController.reloadCollectionView(with: products)
            }
        }
    }
}

// MARK: - AddButtonTappedDelegate

extension MarketViewController: DoneButtonTappedDelegate {
    func registerButtonTapped() {
        reloadCollectionViews()
    }
}

