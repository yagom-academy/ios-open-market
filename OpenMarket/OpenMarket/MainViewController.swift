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
    
    let activity = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activity.center = view.center
        
        mainView.addSubview(tableView)
        mainView.addSubview(collectionView)
        mainView.addSubview(activity)
    
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tableViewNibName = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(tableViewNibName, forCellReuseIdentifier: "TableViewItemCell")
        let CollectionViewNibName = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(CollectionViewNibName, forCellWithReuseIdentifier: "CollectionViewItemCell")
        
        collectionView.isHidden = true
        tableView.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        setupFlowLayout()
        
        segmentedControl.backgroundColor = UIColor.systemBlue
        self.activity.startAnimating()
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
            
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponse.self, from: resultData)
                self.items = apiResponse.items
                
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                        self.activity.stopAnimating()
                        self.tableView.isHidden = false
                        self.navigationController?.isNavigationBarHidden = false
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
        let imageURL: URL! = URL(string: item.thumbnails.first!)
        guard let imageData: Data = try? Data(contentsOf: imageURL) else { return cell }
        
        cell.itemName.text = item.title
        
        if let discountedPrice = item.discountedPrice {
            let attributeString =  NSMutableAttributedString(string: "\(item.currency) \(item.price)")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                                 value: NSUnderlineStyle.single.rawValue,
                                                     range: NSMakeRange(0, attributeString.length))
            cell.itemPrice.attributedText = attributeString
            cell.itemDiscounted.text = "\(item.currency) \(discountedPrice)"
            cell.itemPrice.textColor = .red
            cell.itemDiscounted.textColor = .systemGray
        } else {
            cell.itemPrice.textColor = .systemGray
            cell.itemPrice.text = "\(item.currency) \(item.price)"
            cell.itemDiscounted.isHidden = true
        }
        
        cell.itemThumbnail.image = UIImage(data: imageData)
        cell.itemThumbnail.adjustsImageSizeForAccessibilityContentSizeCategory = false
        cell.itemThumbnail.sizeToFit()
        
        if item.stock == 0 {
            cell.itemQuantity.text = "품절"
            cell.itemQuantity.textColor = .orange
        } else {
            cell.itemQuantity.text = "잔여 수량: \(item.stock)"
            cell.itemQuantity.textColor = .systemGray
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewItemCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        let item: ItemInformation = self.items[indexPath.row]
        let imageURL: URL! = URL(string: item.thumbnails.first!)
        guard let imageData: Data = try? Data(contentsOf: imageURL) else { return cell }
        
        cell.itemName.text = item.title

        if let discountedPrice = item.discountedPrice {
            let attributeString =  NSMutableAttributedString(string: "\(item.currency) \(item.price)")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                                 value: NSUnderlineStyle.single.rawValue,
                                                     range: NSMakeRange(0, attributeString.length))
            cell.itemPrice.attributedText = attributeString
            cell.itemDiscounted.text = "\(item.currency) \(discountedPrice)"
            cell.itemPrice.textColor = .red
            cell.itemDiscounted.textColor = .systemGray
        } else {
            cell.itemPrice.textColor = .systemGray
            cell.itemPrice.text = "\(item.currency) \(item.price)"
            cell.itemDiscounted.isHidden = true
        }
        
        cell.itemThumbnail.image = UIImage(data: imageData)
        cell.itemThumbnail.adjustsImageSizeForAccessibilityContentSizeCategory = false
        cell.itemThumbnail.sizeToFit()
        
        if item.stock == 0 {
            cell.itemQuantity.text = "품절"
            cell.itemQuantity.textColor = .orange
        } else {
            cell.itemQuantity.text = "잔여 수량: \(item.stock)"
            cell.itemQuantity.textColor = .systemGray
        }
    
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
//        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
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
