//
//  OpenMarket - MarketItemsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MarketItemsViewController: UIViewController {
    private let openMarketService = OpenMarketService()
    private var marketItems: [MarketPage.Item] = []
    private var lastPageId: Int = 0
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private var layoutMode: LayoutMode = .list

    private lazy var layoutSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [LayoutMode.list.name, LayoutMode.grid.name])
        segmentedControl.selectedSegmentIndex = LayoutMode.list.rawValue
        segmentedControl.layer.borderWidth = Style.segmentControlBorderWidth
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.addTarget(self, action: #selector(changeLayoutMode), for: .valueChanged)
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
        openMarketService.getPage(id: lastPageId + 1, completionHandler: fetchPageDataCompletionHandler)
    }

    private func fetchPageDataCompletionHandler(_ result: Result<MarketPage, OpenMarketError>) {
        switch result {
        case .success(let page):
            if page.items.isEmpty { return }

            let rangeToInsert: Range<Int> = marketItems.count ..< marketItems.count + page.items.count
            self.marketItems.append(contentsOf: page.items)
            lastPageId = page.id

            DispatchQueue.main.async {
                self.collectionView.insertItems(at: rangeToInsert.map { IndexPath(item: $0, section: 0) })
                self.loadingIndicator.stopAnimating()
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.present(UIAlertController(title: error.name, message: error.description, preferredStyle: .alert),
                             animated: true, completion: nil)
            }
        }
    }

    private func getCellWidth(numberOfcolumns: Int, inset: CGFloat) -> CGFloat {
        let listCellWidth: CGFloat = collectionView.safeAreaLayoutGuide.layoutFrame.width
        let rowWidthWithoutInset: CGFloat = collectionView.safeAreaLayoutGuide.layoutFrame.width - inset * CGFloat(numberOfcolumns + 1)
        let gridCellWidth: CGFloat = rowWidthWithoutInset / CGFloat(numberOfcolumns)

        switch layoutMode {
        case .list:
            return listCellWidth
        case .grid:
            return gridCellWidth
        }
    }

    @objc private func changeLayoutMode() {
        let mode = LayoutMode(rawValue: layoutSegmentedControl.selectedSegmentIndex)!
        layoutMode.changeMode(into: mode)
        collectionView.reloadData()
    }

    @objc func moveToRegisterView() {
        let view = ItemManagingViewController()
        navigationController?.pushViewController(view, animated: true)
    }
}

extension MarketItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marketItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layoutMode {
        case .list:
            return collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.reuseIdentifier, for: indexPath)
        case .grid:
            return collectionView.dequeueReusableCell(withReuseIdentifier: ItemGridCell.reuseIdentifier, for: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == marketItems.count - Style.numberOfCellsToTriggerFetch {
            fetchPageData()
        }

        switch layoutMode {
        case .list:
            guard let itemCell = cell as? ItemListCell else { return }
            itemCell.item = marketItems[indexPath.row]
        case .grid:
            guard let itemCell = cell as? ItemGridCell else { return }
            itemCell.item = marketItems[indexPath.item]
        }
    }
}

extension MarketItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let listCellWidth: CGFloat = collectionView.safeAreaLayoutGuide.layoutFrame.width
        let listCellHeight: CGFloat = Style.listCellHeight
        let gridCellWidth: CGFloat = getCellWidth(numberOfcolumns: 2, inset: 10)
        let gridCellHeight: CGFloat = gridCellWidth * Style.goldenRatio

        return layoutMode == .list ? CGSize(width: listCellWidth, height: listCellHeight) :
            CGSize(width: gridCellWidth, height: gridCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch layoutMode {
        case .grid:
            return UIEdgeInsets(top: 0, left: Style.gridHorizontalInset, bottom: 0, right: Style.gridHorizontalInset)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

extension MarketItemsViewController {
    private enum Style {
        static let goldenRatio: CGFloat = 1.618
        static let gridHorizontalInset: CGFloat = 10
        static let listCellHeight: CGFloat = 70
        static let numberOfCellsToTriggerFetch = 3
        static let numberOfGridColumns: Int = 2
        static let segmentControlBorderWidth: CGFloat = 2
    }

    private enum LayoutMode: Int {
        case list = 0
        case grid = 1

        var name: String {
            switch self {
            case .list:
                return "LIST"
            case .grid:
                return "GRID"
            }
        }

        mutating func changeMode(into layoutMode: LayoutMode) {
            self = layoutMode
        }
    }
}
