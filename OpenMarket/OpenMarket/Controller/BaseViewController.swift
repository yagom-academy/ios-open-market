//
//  BaseViewController.swift
//  OpenMarket
//
//  Created by papri, Tiana on 27/05/2022.
//

import UIKit

class BaseViewController: UIViewController {
    enum Section {
        case main
    }
    var collectionView: UICollectionView?
    var baseView = BaseView()
    var listLayout: UICollectionViewLayout?
    var gridLayout: UICollectionViewLayout?
    
    func applyListLayout() { }
}

// MARK: View life cycle
extension BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        applyListLayout()
        applyGridLayout()
        configureHierarchy(collectionViewLayout: listLayout)
        collectionView?.backgroundColor = .systemBackground
    }
}

// MARK: Navigation Item SetUp
extension BaseViewController {
    func setUpNavigationItem() {
        setUpSegmentation()
        navigationItem.titleView = baseView.segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(touchUpRegisterProduct))
    }
    
    func setUpSegmentation() {
        baseView.segmentedControl.setWidth(view.bounds.width * 0.18 , forSegmentAt: 0)
        baseView.segmentedControl.setWidth(view.bounds.width * 0.18, forSegmentAt: 1)
        baseView.segmentedControl.addTarget(self, action: #selector(switchCollectionViewLayout), for: .valueChanged)
    }
    
    @objc func touchUpRegisterProduct() {
        let registerProductView = UpdateProductViewController()
        let navigationController = UINavigationController(rootViewController: registerProductView)
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func switchCollectionViewLayout() {
        switch baseView.segmentedControl.selectedSegmentIndex {
        case 0:
            guard let listLayout = listLayout else {
                return
            }
            collectionView?.setCollectionViewLayout(listLayout, animated: false)
        case 1:
            guard let gridLayout = gridLayout else {
                return
            }
            collectionView?.setCollectionViewLayout(gridLayout, animated: false)
        default:
            break
        }
    }
}

// MARK: Layout Object creation
extension BaseViewController {
    func applyGridLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        gridLayout = layout
    }
}

// MARK: Layout Collection View
extension BaseViewController {
    func configureHierarchy(collectionViewLayout: UICollectionViewLayout?) {
        guard let collectionViewLayout = collectionViewLayout else {
            return
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout ?? collectionViewLayout)
        view.addSubview(collectionView ?? UICollectionView())
        layoutCollectionView()
    }
    
    func layoutCollectionView() {
        guard let collectionView = collectionView else {
            return
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
