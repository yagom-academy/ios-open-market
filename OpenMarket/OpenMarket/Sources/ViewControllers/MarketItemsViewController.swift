//
//  OpenMarket - MarketItemsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MarketItemsViewController: UIViewController {
    private var pages: [Page] = []

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.startAnimating()
        return indicator
    }()

    private lazy var layoutSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentedControl.selectedSegmentIndex = LayoutMode.list.rawValue
        segmentedControl.layer.borderWidth = 2
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.addTarget(self, action: #selector(toggleLayoutMode), for: .valueChanged)
        return segmentedControl
    }()

    private lazy var registerItemButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(moveToRegisterView))
        return button
    }()

    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInsetReference = .fromSafeArea
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.frame
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        addSubviews()
        configureNavigationItems()
        fetchPageData()
    }

    private func configureCollectionView() {
        collectionView.frame = view.frame
        collectionView.register(ItemListCell.self, forCellWithReuseIdentifier: ItemListCell.reuseIdentifier)
        collectionView.register(ItemGridCell.self, forCellWithReuseIdentifier: ItemGridCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = .systemBackground
    }

    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
    }

    private func configureNavigationItems() {
        navigationItem.titleView = layoutSegmentedControl
        navigationItem.rightBarButtonItem = registerItemButton
    }

    private func fetchPageData() {
        SessionManager.shared.request(method: .get, path: .page(id: pages.count + 1)) { (result: Result<Page, OpenMarketError>) in
            switch result {
            case .success(let page):
                self.pages.append(page)
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            case .failure:
                DispatchQueue.main.async {
                    self.present(UIAlertController(title: "Failed to fetch Data", message: nil, preferredStyle: .alert),
                                 animated: true, completion: nil)
                }
                return
            }
        }
    }

    @objc private func toggleLayoutMode() {
        LayoutMode.toggle()
        collectionView.reloadData()
    }

    @objc func moveToRegisterView() {
        let view = ItemManagingViewController()
        navigationController?.pushViewController(view, animated: true)
    }
}

extension MarketItemsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return pages.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch LayoutMode.current {
        case .list:
            guard let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.reuseIdentifier,
                                                                for: indexPath) as? ItemListCell else {
                return ItemListCell()
            }
            itemCell.item = pages[indexPath.section].items[indexPath.item]
            return itemCell
        case .grid:
            guard let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemGridCell.reuseIdentifier,
                                                                for: indexPath) as? ItemGridCell else {
                return ItemListCell()
            }
            itemCell.item = pages[indexPath.section].items[indexPath.item]
            return itemCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return LayoutMode.current == .grid ? CGSize(width: 1, height: 10) : CGSize(width: 0, height: 0)
    }
}

extension MarketItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let listCellWidth: CGFloat = view.safeAreaLayoutGuide.layoutFrame.width
        let listCellHeight: CGFloat = 70
        let gridCellWidth: CGFloat = (view.safeAreaLayoutGuide.layoutFrame.width - 30) / 2
        let gridCellHeight: CGFloat = gridCellWidth * 1.618

        return LayoutMode.current == .list ? CGSize(width: listCellWidth, height: listCellHeight) :
            CGSize(width: gridCellWidth, height: gridCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return LayoutMode.current == .list ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

extension MarketItemsViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let lastPageItemCount = pages.last?.items.count,
              let lastIndexPathsSection = indexPaths.last?.section else { return }

        if indexPaths.contains(IndexPath(row: lastPageItemCount - 1, section: lastIndexPathsSection)) {
            fetchPageData()
        }
    }
}

enum LayoutMode: Int {
    static var current: LayoutMode = .list
    case list = 0
    case grid = 1

    static func toggle() {
        switch current {
        case .list: current = .grid
        case .grid: current = .list
        }
    }
}
