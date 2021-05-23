//
//  OpenMarket - MarketItemsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MarketItemsViewController: UIViewController {
    private var page: Page?

    private lazy var layoutSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentedControl.selectedSegmentIndex = LayoutMode.list.rawValue
        segmentedControl.addTarget(self, action: #selector(toggleLayoutMode), for: .valueChanged)
        return segmentedControl
    }()

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.frame
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        navigationItem.titleView = layoutSegmentedControl
        fetchPageData()
    }

    @objc private func toggleLayoutMode() {
        LayoutMode.toggle()
        collectionView.reloadData()
    }

    private func fetchPageData() {
        SessionManager.shared.request(method: .get, path: .page(id: 1)) { (result: Result<Page, OpenMarketError>) in
            switch result {
            case .success(let page):
                self.page = page
                DispatchQueue.main.async {
                    // TODO: Loading 화면 끝
                    self.collectionView.reloadData()
                }
            case .failure:
                // TODO: Alert 띄우기
                return
            }
        }
    }
}

extension MarketItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return page?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier,
                                                            for: indexPath) as? ItemCell else {
            return ItemCell()
        }
        itemCell.item = page?.items[indexPath.item]

        return itemCell
    }
}

extension MarketItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let listCellWidth: CGFloat = view.safeAreaLayoutGuide.layoutFrame.width
        let listCellHeight: CGFloat = 70
        let gridCellWidth: CGFloat = (view.frame.width - 30) / 2
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
