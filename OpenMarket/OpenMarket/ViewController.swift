//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    var tableView: UITableView!
    var collectionView: UICollectionView!
    
    @IBOutlet var superView: UIView!
    @IBOutlet var control: UISegmentedControl!
    
    @IBAction func didChangeSegement(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // 테이블 뷰
            superView.addSubview(tableView)
            control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: UIControl.State.selected)
            return
        }
        
        
        superView.addSubview(collectionView)
        // 콜렉션 뷰
        
        return
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        control.backgroundColor = UIColor.white
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: UIControl.State.selected)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let tableViewNib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(tableViewNib, forCellReuseIdentifier: "TableViewCell")
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let collectionViewNib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionView.register(collectionViewNib, forCellWithReuseIdentifier: "CollectionViewCell")
        
    }
    
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell else {
            return UITableViewCell()
        }
      
        return cell
    }
    

    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UICollectionViewDelegate {
    
}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else  {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .red
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: superView.frame.width/2-10, height: superView.frame.height/4)
    }
}

