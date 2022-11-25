//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/25.
//

import UIKit

final class AddProductViewController: UIViewController {
    let text: UILabel = {
        let text = UILabel()
        text.text = "😎"
        text.font = .preferredFont(forTextStyle: .title1)
        
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(text)
        NSLayoutConstraint.activate([
            text.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            text.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        
        ])
        
        self.view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
