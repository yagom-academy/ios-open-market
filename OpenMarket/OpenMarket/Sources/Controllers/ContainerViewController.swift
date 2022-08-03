//
//  ItemContainerViewController.swift
//  OpenMarket
//
//  Created by minsson on 2022/08/03.
//

import UIKit

final class ContainerViewController: UIViewController {
    
    // MARK: - Private Enums
    
    private enum DisplayingViewType: Int {
        case list = 0
        case grid = 1
    }
    
    private enum QueryValues {
        static let pageNumber = 1
        static let itemsPerPage = 50
    }
    
    // MARK: - Properties
    
    private let segmentedControl: UISegmentedControl = {
        let selectionItems = [
            UIImage(systemName: "rectangle.grid.1x2"),
            UIImage(systemName: "square.grid.2x2")
        ]
        
        let segmentedControl = UISegmentedControl(items: selectionItems as [Any])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private lazy var listCollectionViewController: ListCollectionViewController = {
        let listCollectionViewController = ListCollectionViewController()
        return listCollectionViewController
    }()
    
    private lazy var gridCollectionViewController: GridCollectionViewController = {
        let gridCollectionViewController = GridCollectionViewController()
        gridCollectionViewController.view.isHidden = true
        return gridCollectionViewController
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIURLComponents.configureQueryItem(
            pageNumber: QueryValues.pageNumber,
            itemsPerPage: QueryValues.itemsPerPage
        )
        
        addSubViewToViewController()
        setupUIComponentsLayout()
        segmentedControlDidTap()
    }
}

// MARK: - Private Properties

private extension ContainerViewController {
    func addSubViewToViewController() {
        view.addSubview(listCollectionViewController.view)
        view.addSubview(gridCollectionViewController.view)
        view.addSubview(segmentedControl)
        
        addChild(listCollectionViewController)
        addChild(gridCollectionViewController)
        
        listCollectionViewController.didMove(toParent: self)
        gridCollectionViewController.didMove(toParent: self)
        
        gridCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        listCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func segmentedControlDidTap() {
        segmentedControl.addTarget(
            self,
            action: #selector(switchLayout),
            for: .valueChanged
        )
    }
    
    @objc func switchLayout(segmentedControl: UISegmentedControl) {
        switch DisplayingViewType(rawValue: segmentedControl.selectedSegmentIndex) {
        case .list:
            gridCollectionViewController.view.isHidden = true
            listCollectionViewController.view.isHidden = false
        case .grid:
            gridCollectionViewController.view.isHidden = false
            listCollectionViewController.view.isHidden = true
        case .none:
            break
        }
    }
    
    func setupUIComponentsLayout() {
        setupSegmentedControlLayout()
        setupGridCollectionViewLayout()
        setupListCollectionViewLayout()
    }
    
    func setupGridCollectionViewLayout() {
        NSLayoutConstraint.activate([
            gridCollectionViewController.view.topAnchor.constraint(
                equalTo: segmentedControl.bottomAnchor,
                constant: 5
            ),
            gridCollectionViewController.view.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -5
            ),
            gridCollectionViewController.view.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 5
            ),
            gridCollectionViewController.view.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -5
            )
        ])
    }
    
    func setupSegmentedControlLayout() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 30
            ),
            segmentedControl.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 30
            ),
            segmentedControl.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -30
            )
        ])
    }
    
    func setupListCollectionViewLayout() {
        NSLayoutConstraint.activate([
            listCollectionViewController.view.topAnchor.constraint(
                equalTo: segmentedControl.bottomAnchor,
                constant: 5
            ),
            listCollectionViewController.view.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -5
            ),
            listCollectionViewController.view.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 5
            ),
            listCollectionViewController.view.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -5
            )
        ])
    }
}
