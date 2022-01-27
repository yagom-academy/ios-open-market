//
//  ProductPageTypeAlias.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/28.
//

import UIKit

typealias OpenMarketDiffableDataSource = UICollectionViewDiffableDataSource<Int, Product>
typealias OpenMarketSnapshot = NSDiffableDataSourceSnapshot<Int, Product>
typealias OpenMarketCellRegistration = UICollectionView.CellRegistration
typealias OpenMarketListCellRegistration = OpenMarketCellRegistration<OpenMarketListCollectionViewCell, Product>
typealias OpenMarketGridCellRegistration = OpenMarketCellRegistration<OpenMarketGridCollectionViewCell, Product>
