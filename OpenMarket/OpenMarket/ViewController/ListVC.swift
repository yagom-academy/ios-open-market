//
//  ListVC.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/14.
//

import UIKit

class ListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(Self.setupItems(_:)), name: NotificationNames.items.notificaion, object: nil)
    }
    
    @objc func setupItems(_ notification: Notification) {
        if let receiveItems = notification.object as? [Item] {
            self.items = receiveItems
            
            print("노티 받기 완료!")
            
            DispatchQueue.main.async {
                print("리로드데이터 실행!")
                self.tableView.reloadData()
            }
        }
    }
    
}

extension ListVC: UITableViewDelegate {

    
}

extension ListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListVCCell") as! ListVCCell
        
        cell.setup()
        
        if self.items.count > 0 {
            cell.item = items[indexPath.row]
            cell.setupItem()
        }
        
        return cell
    }

    
}
