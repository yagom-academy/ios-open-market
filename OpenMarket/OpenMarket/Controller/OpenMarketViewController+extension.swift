//
//  OpenMarketViewController.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/17.
//

import UIKit

extension OpenMarketViewController {
    func setUI(){
        self.setSubviews()
        self.setNavigationController()
        self.setSegmentedControl()
        self.setListViewConstraints()
        self.setGridViewConstraints()
    }
    
    func setSubviews() {
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.listCollectionView)
        self.view.addSubview(self.gridCollectionView)
    }
    
    func setNavigationController() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.titleView = segmentedControl
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem
        = UIBarButtonItem(image: UIImage(systemName: "plus"),
                          style: .plain,
                          target: self,
                          action: #selector(productRegistrationButtonDidTap))
    }
    
    func setSegmentedControl() {
        self.segmentedControl.addTarget(self,
                                        action: #selector(segmentButtonDidTap(sender:)),
                                        for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentButtonDidTap(sender: self.segmentedControl)
    }
    
    func setListViewConstraints() {
        NSLayoutConstraint.activate([
            self.listCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.listCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.listCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.listCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func setGridViewConstraints() {
        NSLayoutConstraint.activate([
            self.gridCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.gridCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.gridCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.gridCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func showSpinner(on view : UIView) {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicatorView = UIActivityIndicatorView.init(style: .large)
        activityIndicatorView.startAnimating()
        activityIndicatorView.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicatorView)
            view.addSubview(spinnerView)
        }
        
        loadingView = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }
}
