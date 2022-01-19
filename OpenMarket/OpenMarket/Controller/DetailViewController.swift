//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/19.
//

import UIKit

class DetailViewController: UIViewController {
    private var images = [UIImage]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bagainPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tappedEditButton(_ sendor: UIButton) {

    }
}
