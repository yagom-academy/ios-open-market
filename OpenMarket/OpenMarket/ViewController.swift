//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let imageURL0 = "https://wallpaperaccess.com/download/europe-4k-1369012"
    let imageURL1 = "https://wallpaperaccess.com/download/europe-4k-1318341"
    let imageURL2 = "https://wallpaperaccess.com/download/europe-4k-1379801"
    var image0: UIImage?
    var image1: UIImage?
    var image2: UIImage?
    var urlList: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let tableViewNib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(tableViewNib, forCellReuseIdentifier: "TableViewCell")
        
        guard let url0 = URL(string: imageURL0) else { fatalError() }
        guard let url1 = URL(string: imageURL1) else { fatalError() }
        guard let url2 = URL(string: imageURL2) else { fatalError() }
        urlList = [url0, url1, url2]
        
        let session = URLSession.shared
        let task0 = session.dataTask(with: url0) {data, reponse, error in
            if let error = error {
                print(error)
                return
            } else if let data = data {
                self.image0 = UIImage(data: data)
            }
        }
        
        let task1 = session.dataTask(with: url1) {data, reponse, error in
            if let error = error {
                print(error)
                return
            } else if let data = data {
                self.image1 = UIImage(data: data)
            }
        }
        
        let task2 = session.dataTask(with: url2) {data, reponse, error in
            if let error = error {
                print(error)
                return
            }else if let data = data {
                self.image2 = UIImage(data: data)
            }
        }
        
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            
        }
        
        if indexPath.row == 3 {
            cell.backgroundColor = UIColor.red
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        if indexPath.section <= 4 {
            cell.number.text = "\(indexPath.section), \(indexPath.row)"
        } else {
            cell.number.text = ""
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Header \(section)"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}
