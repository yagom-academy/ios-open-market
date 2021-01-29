//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    let productListTableView = UITableView()
    let item = ["a","b","c"]
    let listPresentingStyleSelection = ["LIST","GRID"]
    lazy var productRegistrationButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(registrationButtonTapped(_:)))
        return button
    }()
    lazy var listPresentingStyleSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: listPresentingStyleSelection)
        control.selectedSegmentIndex = 0
        control.layer.borderColor = UIColor.systemBlue.cgColor
        control.tintColor = .systemBlue
        control.selectedSegmentTintColor = .systemBlue
        control.addTarget(self, action: #selector(handleSegmentedControlValueChanged(_:)), for: .valueChanged)
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        productListTableView.delegate = self
        productListTableView.dataSource = self
        productListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(productListTableView)
        setUpProductListView()
        self.navigationItem.titleView = listPresentingStyleSegmentControl
        self.navigationItem.rightBarButtonItem = productRegistrationButton
    }

    private func setUpProductListView() {
        productListTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: productListTableView,
             attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top,
             multiplier: 1.0, constant: 0))
           self.view.addConstraint(NSLayoutConstraint(item: productListTableView,
             attribute: .bottom, relatedBy: .equal, toItem: self.view,
             attribute: .bottom, multiplier: 1.0, constant: 0))
           self.view.addConstraint(NSLayoutConstraint(item: productListTableView,
             attribute: .leading, relatedBy: .equal, toItem: self.view,
             attribute: .leading, multiplier: 1.0, constant: 0))
           self.view.addConstraint(NSLayoutConstraint(item: productListTableView,
             attribute: .trailing, relatedBy: .equal, toItem: self.view,
             attribute: .trailing, multiplier: 1.0, constant: 0))
    }
}
extension ViewController: UITableViewDelegate {
    
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = item[indexPath.row]
        return cell
    }
}
extension ViewController {
    @objc private func handleSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            productListTableView.isHidden = false
            setUpProductListView()
        case 1:
            productListTableView.isHidden = true
            view.backgroundColor = .red
        default:
            setUpProductListView()
        }
    }
    
    @objc private func registrationButtonTapped(_ sender: Any) {
        print("button pressed")
    }
}
