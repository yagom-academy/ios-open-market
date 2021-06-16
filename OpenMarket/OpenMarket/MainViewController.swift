//
//  MainViewController.swift
//  OpenMarket
//
//  Created by Sunny on 2021/06/14.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.addSubview(tableView)
        mainView.addSubview(collectionView)
    
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tableViewNibName = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(tableViewNibName, forCellReuseIdentifier: "TableViewItemCell")
        let CollectionViewNibName = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(CollectionViewNibName, forCellWithReuseIdentifier: "CollectionViewItemCell")
        
        collectionView.isHidden = true
        setupFlowLayout()
        
        segmentedControl.backgroundColor = UIColor.systemBlue
        }
    
    @IBAction func switchViewsBySegmentedControl(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableView.isHidden = false
            collectionView.isHidden = true
        case 1:
            tableView.isHidden = true
            collectionView.isHidden = false
        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let url = URL(string: "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png") else { return UITableViewCell()}
        let data = try! Data(contentsOf: url)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewItemCell", for: indexPath) as! TableViewCell
        cell.itemName.text = "MacBook Pro"
        cell.itemPrice.text = "1800000"
        cell.itemThumbnail.image = UIImage(data: data)
        cell.itemThumbnail.adjustsImageSizeForAccessibilityContentSizeCategory = false
        cell.itemThumbnail.sizeToFit()
        cell.itemQuantity.text = "수량 : 128"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let url = URL(string: "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png") else { return UICollectionViewCell()}
        let data = try! Data(contentsOf: url)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewItemCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.itemName.text = "MacBook Pro"
        cell.itemPrice.text = "1800000"
        cell.itemImage.image = UIImage(data: data)
        cell.itemImage.adjustsImageSizeForAccessibilityContentSizeCategory = false
        cell.itemImage.sizeToFit()
        cell.itemQuantity.text = "수량 : 128"
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        let halfWidth = UIScreen.main.bounds.width / 2
        flowLayout.itemSize = CGSize(width: halfWidth * 0.8 , height: halfWidth)
        
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 250)
    }
}
