//
//  PageViewController.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import UIKit

final class PageViewController: UIViewController, DataRepresentable {
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!


    private let datamanager = GetManager()
    var snapshot = NSDiffableDataSourceSnapshot<Int, Product>()
    
    private var currentCollectionView: UICollectionView?
    
    private let listCollectionView: UICollectionView
    private let gridCollectionView: UICollectionView
    private let listDataSource: UICollectionViewDiffableDataSource<Int, Product>
    private let gridDataSource: UICollectionViewDiffableDataSource<Int, Product>
    
    required init?(coder: NSCoder) {
        self.listCollectionView = UICollectionView(frame: .zero,
                                                   collectionViewLayout: OpenMarketLayout.list.layout)
        self.gridCollectionView = UICollectionView(frame: .zero,
                                                   collectionViewLayout: OpenMarketLayout.grid.layout)
        self.gridDataSource = OpenMarketLayout.grid.createDataSource(for: gridCollectionView,
                                                                     cellType: GridCollectionViewCell.self)
        self.listDataSource = OpenMarketLayout.list.createDataSource(for: listCollectionView,
                                                                     cellType: ListCollectionViewCell.self)
        self.snapshot.appendSections([0])
        super.init(coder: coder)
        self.listCollectionView.delegate = self
        self.gridCollectionView.delegate = self
        self.datamanager.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        configureSegmentedConrol()
        configureViewLayout()
        view.bringSubviewToFront(activityIndicator)
        datamanager.update(completion: applyDataToCurrentView)
    }

    @IBAction func addProductButtonDidTab(_ sender: UIBarButtonItem) {
        let addProductVC = AddProductViewController()
        let naviController = UINavigationController()
        naviController.addChild(addProductVC)
        naviController.modalPresentationStyle = .fullScreen
        present(naviController, animated: true, completion: nil)
    }

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        configureViewLayout()
        applyDataToCurrentView()
    }
}

// MARK: - UICollectionViewDelegate Protocol RequireMents
extension PageViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height >= scrollView.contentSize.height {
            datamanager.nextPage(completion: applyDataToCurrentView)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

// MARK: - Updating Layout
extension PageViewController {
    
    private func configureSegmentedConrol() {
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.backgroundColor = UIColor(cgColor: CGColor(red: 255, green: 255, blue: 255, alpha: 0))
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: UIControl.State.normal)
        
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.layer.borderWidth = 2
    }

    private func configureViewLayout() {
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

    private func applyDataToCurrentView() {
        DispatchQueue.main.async {
            self.segmentedControl.selectedSegmentIndex == 0 ?
                self.listDataSource.apply(self.snapshot)
                : self.gridDataSource.apply(self.snapshot)
            
            self.activityIndicator.stopAnimating()
        }
    }
    
}
