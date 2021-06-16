//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var SegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.addSubview(tableView)
        mainView.addSubview(collectionView)
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableViewRegisterXib(fileName: "CustomTableViewCell", cellIdentifier: "CustomTableViewCell")
        collectionViewRegisterXib(fileName: "CustomCollectionViewCell", cellIdentifier: "CustomCollectionViewCell")
        
        collectionView.isHidden = true
    }


    @IBAction func ChangeViewBySegmentedControl(_ sender: UISegmentedControl) {
        if SegmentedControl.selectedSegmentIndex == 0 {
            collectionView.isHidden = true
            tableView.isHidden = false
        } else if SegmentedControl.selectedSegmentIndex == 1 {
            collectionView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    private func tableViewRegisterXib(fileName: String, cellIdentifier: String) {
            let nibName = UINib(nibName: fileName, bundle: nil)
            tableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func collectionViewRegisterXib(fileName: String, cellIdentifier: String) {
            let nibName = UINib(nibName: fileName, bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: cellIdentifier)
    }
}


extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell else {
            fatalError("cell 생성 실패")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}


extension ViewController: UICollectionViewDelegate {

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
            fatalError("CollecionViewCell 생성 실패")
        }

        return cell
    }
}
