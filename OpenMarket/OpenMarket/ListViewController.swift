//
//  ListViewController.swift
//  OpenMarket
//
//  Created by 김태형 on 2021/01/30.
//

import UIKit

class ListViewController: UIViewController {
    let tableView = UITableView()
    //    let productList: ProductList = ProductList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(ProductListTableViewCell.self, forCellReuseIdentifier: "ProductListTableViewCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    
        let safeLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
    }
}

extension ListViewController: UITableViewDelegate {
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as? ProductListTableViewCell else {
            debugPrint("CellError")
            return UITableViewCell()
        }
        return cell
    }
    
}

