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
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var items: [ItemShortInformaion] = []
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let urlString = "https://camp-open-market-2.herokuapp.com/items/1"
        guard let url = URL(string: urlString) else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard error == nil else { return }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            guard (200..<300).contains(statusCode) else { return }
            
            guard let resultData = data else { return }
            
            let resultString = String(data: resultData, encoding: .utf8 )
            

            do {
                let decoder = JSONDecoder()
                let itemPage = try decoder.decode(ItemPage.self, from: resultData)
                self.items = itemPage.items
                print("\(self.items)")

            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
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
    
    // tableViewCell 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}


extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 60
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
            fatalError("CollecionViewCell 생성 실패")
        }
        
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height/3)
    }

}
