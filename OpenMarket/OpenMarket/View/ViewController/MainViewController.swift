//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items: [ItemShortInformaion] = []
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getItemPageInfo()
    }
    
    func getItemPageInfo() {
        let networkManager = NetworkManager()
        let url:URL = networkManager.url
        
        let session: URLSession = URLSession(configuration: .default)
        
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard error == nil else { return }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            guard (200..<300).contains(statusCode) else { return }

            guard let resultData = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let itemPage = try decoder.decode(ItemPage.self, from: resultData)
                self.items = itemPage.items

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    self.navigationController?.isNavigationBarHidden = false
                    self.tableView.isHidden = false
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    @IBAction func changeViewBySegmentedControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case ViewType.List.rawValue:
            collectionView.isHidden = true
            tableView.isHidden = false
        case ViewType.Grid.rawValue:
            collectionView.isHidden = false
            tableView.isHidden = true
        default:
            break
        }
    }
    
    private func registerTableViewCellXib() {
        let nibName = UINib(nibName: CustomTableViewCell.identifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: CustomTableViewCell.identifier)
    }
    
    private func registerCollectionViewCellXib() {
        let nibName = UINib(nibName: CustomCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
    }
    
    private func setupView() {
        
        setupActivityIndicator()
        tableView.isHidden = true
        navigationController?.isNavigationBarHidden = true
        activityIndicator.startAnimating()
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        registerTableViewCellXib()
        registerCollectionViewCellXib()
        
        collectionView.isHidden = true
        
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    private func setupActivityIndicator() {
        mainView.addSubview(activityIndicator)
        
        activityIndicator.style = .large
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.blue
    }
    
    func changeNumberFomatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let result = numberFormatter.string(from: NSNumber(value:number))!
        
        return result
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier) as? CustomTableViewCell else {
            print(APIError.tableViewCell)
            return UITableViewCell()
        }
        
        let item: ItemShortInformaion = self.items[indexPath.row]
        
//        let customTableViewCell = CustomTableViewCell()
//        customTableViewCell.configure(item: item)
        
        cell.titleLabel.text = item.title
        cell.priceLabel.text = "USD " + changeNumberFomatter(number: Int(item.price))
        
        if item.discountedPrice == nil {
            cell.discountedPriceLabel.isHidden = true
        } else {
            cell.discountedPriceLabel.text =
                "USD " + changeNumberFomatter(number: item.discountedPrice!)
            cell.priceLabel.attributedText = cell.priceLabel.text?.strikeThrough()
        }
        
        if item.stock == 0 {
            cell.stockLabel.text = "품절"
            cell.stockLabel.textColor = UIColor.orange
        } else {
            cell.stockLabel.text = "잔여수량: " + changeNumberFomatter(number: item.stock)
            cell.stockLabel.textColor = UIColor.lightGray
        }
        
        DispatchQueue.main.async {
            guard let imageURL = URL(string: item.thumbnailURLs[0]) else {
                print(APIError.image)
                return
            }
            guard let imageData = try? Data(contentsOf: imageURL) else {
                print(APIError.image)
                return
            }
            cell.itemImage.image = UIImage(data: imageData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellHeight = 70
        
        return CGFloat(cellHeight)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            print(APIError.collectionViewCell)
            return UICollectionViewCell()
        }
        
        let item: ItemShortInformaion = self.items[indexPath.row]
        
//        let customCollectionViewCell = CustomCollectionViewCell()
//        customCollectionViewCell.configure(item: item)
        
        cell.titleLabel.text = item.title
        cell.priceLabel.text = "USD " + changeNumberFomatter(number: Int(item.price))
        
        if item.discountedPrice == nil {
            cell.discountedPriceLabel.isHidden = true
        } else {
            cell.discountedPriceLabel.text =
                "USD " + changeNumberFomatter(number: item.discountedPrice!)
            cell.priceLabel.attributedText = cell.priceLabel.text?.strikeThrough()
        }
        
        if item.stock == 0 {
            cell.stockLabel.text = "품절"
            cell.stockLabel.textColor = UIColor.orange
        } else {
            cell.stockLabel.text = "잔여수량: " + changeNumberFomatter(number: item.stock)
            cell.stockLabel.textColor = UIColor.lightGray
        }
        
        DispatchQueue.main.async {
            guard let imageURL = URL(string: item.thumbnailURLs[0]) else {
                print(APIError.image)
                return
            }
            guard let imageData = try? Data(contentsOf: imageURL) else {
                print(APIError.image)
                return
            }
            cell.itemImage.image = UIImage(data: imageData)
        }
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let twoItem = 2
        let threeItem = 3
        let spacingBetweenItems = 5
        
        return CGSize(width: Int(collectionView.frame.width)/twoItem-spacingBetweenItems, height: Int(collectionView.frame.height)/threeItem)
    }
}




