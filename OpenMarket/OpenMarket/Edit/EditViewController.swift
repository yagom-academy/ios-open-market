//
//  EditViewController.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/24.
//

import UIKit

private enum Section {
    case main
}

final class EditViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UIImage>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
    
    private var mainView: EditView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        super.loadView()
        mainView = EditView(frame: view.bounds)
        mainView?.backgroundColor = .systemBackground
        view = mainView
    }
}
