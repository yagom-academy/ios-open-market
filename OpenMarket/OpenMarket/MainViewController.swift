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
    
    var items: [ItemInformation] = []
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let urlString = "https://camp-open-market-2.herokuapp.com/items/1"
        guard let url = URL(string: urlString) else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard error == nil else { return }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            let successRange = 200..<300
            
            guard successRange.contains(statusCode) else { return }
            
            guard let resultData = data else { return }
            let resultString = String(data: resultData, encoding: .utf8)
            
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponse.self, from: resultData)
                self.items = apiResponse.items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        dataTask.resume()
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
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewItemCell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        let item: ItemInformation = self.items[indexPath.row]
        
        cell.itemName.text = item.title
        cell.itemPrice.text = String(item.price)
        
        let imageURL: URL! = URL(string: item.thumbnails.first!)
        guard let imageData: Data = try? Data(contentsOf: imageURL) else { return cell }
        cell.itemThumbnail.image = UIImage(data: imageData)
        cell.itemThumbnail.adjustsImageSizeForAccessibilityContentSizeCategory = false
        cell.itemThumbnail.sizeToFit()
        cell.itemQuantity.text = String(item.stock)
        
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
//        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
