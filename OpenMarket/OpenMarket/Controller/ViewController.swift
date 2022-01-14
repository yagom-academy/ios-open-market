//
//  ViewController.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let datamanager = DataManager()
    var snapshot = NSDiffableDataSourceSnapshot<Int, Product>()
    
    var currentCollectionView: UICollectionView?
    
    let listCollectionView: UICollectionView
    let gridCollectionView: UICollectionView
    let listDataSource: UICollectionViewDiffableDataSource<Int, Product>
    let gridDataSource: UICollectionViewDiffableDataSource<Int, Product>
    
    required init?(coder: NSCoder) {
        self.listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: OpenMarketLayout.list.layout)
        self.gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: OpenMarketLayout.grid.layout)
        self.gridDataSource = OpenMarketLayout.grid.createDataSource(for: gridCollectionView)
        self.listDataSource = OpenMarketLayout.list.createDataSource(for: listCollectionView)
        self.snapshot.appendSections([0])
        super.init(coder: coder)
        self.listCollectionView.delegate = self
        self.gridCollectionView.delegate = self
        self.datamanager.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewLayout()
        datamanager.update()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        configureViewLayout()
        applyDataToCurrentView()
    }
}

// MARK: - DataRepresentable Protocol RequireMents
extension ViewController: DataRepresentable {
    
    func dataDidChange(data: [Product]) {
        snapshot.appendItems(data)
        applyDataToCurrentView()
    }
    
}

// MARK: - UICollectionViewDelegate Protocol RequireMents
extension ViewController: UICollectionViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let endPoint = CGPoint(x: 0, y: scrollView.contentSize.height)
        if targetContentOffset.pointee.y + scrollView.frame.height >= endPoint.y {
            datamanager.nextPage()
            applyDataToCurrentView()
        }
    }
}


// MARK: - Updating Layout
extension ViewController {
    
    func configureViewLayout() {
        if currentCollectionView != nil {
            currentCollectionView?.removeFromSuperview()
        }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            currentCollectionView = listCollectionView
        default:
            currentCollectionView = gridCollectionView
        }
        
        guard let collectionView = currentCollectionView else { return }
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }

    func applyDataToCurrentView() {
        DispatchQueue.main.async {
            self.segmentedControl.selectedSegmentIndex == 0 ?
                self.listDataSource.apply(self.snapshot)
                : self.gridDataSource.apply(self.snapshot)
        }
    }
    
}
