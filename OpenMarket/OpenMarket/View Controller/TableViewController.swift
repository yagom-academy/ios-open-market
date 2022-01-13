////
////  TableViewController.swift
////  OpenMarket
////
////  Created by 고은 on 2022/01/13.
//
//import UIKit
//
//class TableViewController: UITableViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//        cell.backgroundColor = .systemIndigo
//        
//        return cell
//    }
//}
