//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    var tableView: UITableView!
    var collectionView: UICollectionView!
    var url: URLComponents?
    
    @IBOutlet var superView: UIView!
    @IBOutlet var control: UISegmentedControl!
    @IBAction func didChangeSegement(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            collectionView.removeFromSuperview()
            superView.addSubview(tableView)
            control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                           for: UIControl.State.selected)
            control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue],
                                           for: UIControl.State.normal)
            return
        }
        tableView.removeFromSuperview()
        superView.addSubview(collectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentedControl()
        setUpTableView()
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: 10, y: 10, width: superView.frame.width-20, height: superView.frame.height), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let collectionViewNib = UINib(nibName: CollectionViewCell.identifier, bundle: nil)
        self.collectionView.register(collectionViewNib, forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    
    private func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let tableViewNib = UINib(nibName: TableViewCell.identifier, bundle: nil)
        tableView.register(tableViewNib, forCellReuseIdentifier: TableViewCell.identifier)
        superView.addSubview(tableView)
    }
    
    private func setUpSegmentedControl() {
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue],
                                       for: UIControl.State.normal)
        control.layer.borderWidth = 0.5
        control.layer.borderColor = UIColor.systemBlue.cgColor
        control.backgroundColor = UIColor.white
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white],
                                       for: UIControl.State.selected)
    }
    
    func checkValidation(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            fatalError("\(error)")
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid Response")
            return
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Status Code: \(httpResponse.statusCode)")
            return
        }
        guard let _ = data else {
            print("Invalid Data")
            return
        }
    }
    
    func getItemsOfPageData(tableViewCell: TableViewCell?, collectionViewCell: CollectionViewCell?, indexPath: IndexPath)  {
                
        let url = Network.baseURL + "/items/\(indexPath.row/20+1)"
        guard let urlRequest = URL(string: url) else { return  }

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            self.checkValidation(data: data, response: response, error: error)
            do {
                let data = try JSONDecoder().decode(ItemsOfPageReponse.self, from: data!)
                if let tableViewCell = tableViewCell {
                    tableViewCell.update(data: data, indexPath: indexPath ,tableView: self.tableView)
                }
                guard let collectionViewCell = collectionViewCell else { return }
                collectionViewCell.update(data: data, indexPath: indexPath, collectionView: self.collectionView)
            } catch {
                fatalError("Failed to decode")
            }
        }.resume()
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 119
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }
        
        getItemsOfPageData(tableViewCell: cell, collectionViewCell: nil, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 119
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else  {
            return UICollectionViewCell()
        }
        
        getItemsOfPageData(tableViewCell: nil, collectionViewCell: cell, indexPath: indexPath)
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: superView.frame.width/2-20, height: superView.frame.height/2.8)
    }
}

