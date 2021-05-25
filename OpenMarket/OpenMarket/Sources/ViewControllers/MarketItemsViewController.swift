//
//  OpenMarket - MarketItemsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MarketItemsViewController: UIViewController {
    private enum Style {
        static let goldenRatio: CGFloat = 1.618
        static let gridHorizontalInset: CGFloat = 10
        static let gridVerticalInset: CGFloat = 10
        static let listCellHeight: CGFloat = 70
        static let numberOfGridColumns: Int = 2
        static let segmentControlBorderWidth: CGFloat = 2
    }

    private var pages: [Page] = []

    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    private lazy var layoutSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [LayoutMode.list.name, LayoutMode.grid.name])
        segmentedControl.selectedSegmentIndex = LayoutMode.list.rawValue
        segmentedControl.layer.borderWidth = Style.segmentControlBorderWidth
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

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureCollectionView()
        configureLoadingIndicator()
        configureNavigationItems()
        fetchPageData()
    }

    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
    }

    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.register(ItemListCell.self, forCellWithReuseIdentifier: ItemListCell.reuseIdentifier)
        collectionView.register(ItemGridCell.self, forCellWithReuseIdentifier: ItemGridCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = .systemBackground
    }

    private func configureLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
        loadingIndicator.startAnimating()
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
            case .failure(let error):
                DispatchQueue.main.async {
                    self.present(UIAlertController(title: "Error", message: error.description, preferredStyle: .alert),
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
        switch LayoutMode.current {
        case .grid:
            return CGSize(width: 0, height: Style.gridVerticalInset)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}

extension MarketItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let listCellWidth: CGFloat = collectionView.safeAreaLayoutGuide.layoutFrame.width
        let listCellHeight: CGFloat = Style.listCellHeight
        let gridCellWidth: CGFloat = collectionView.getCellWidth(numberOfcolumns: 2, inset: 10)
        let gridCellHeight: CGFloat = gridCellWidth * Style.goldenRatio

        return LayoutMode.current == .list ? CGSize(width: listCellWidth, height: listCellHeight) :
            CGSize(width: gridCellWidth, height: gridCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch LayoutMode.current {
        case .grid:
            return UIEdgeInsets(top: 0, left: Style.gridHorizontalInset, bottom: 0, right: Style.gridHorizontalInset)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

extension UICollectionView {
    func getCellWidth(numberOfcolumns: Int, inset: CGFloat) -> CGFloat {
        let listCellWidth: CGFloat = safeAreaLayoutGuide.layoutFrame.width
        let rowWidthWithoutInset: CGFloat = safeAreaLayoutGuide.layoutFrame.width - inset * CGFloat(numberOfcolumns + 1)
        let gridCellWidth: CGFloat = rowWidthWithoutInset / CGFloat(numberOfcolumns)

        switch LayoutMode.current {
        case .list:
            return listCellWidth
        case .grid:
            return gridCellWidth
        }
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
    case list = 0
    case grid = 1

    static var current: LayoutMode = .list

    var name: String {
        switch self {
        case .list:
            return "LIST"
        case .grid:
            return "GRID"
        }
    }

    static func toggle() {
        switch current {
        case .list: current = .grid
        case .grid: current = .list
        }
    }
}
