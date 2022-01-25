//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/25.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    let images = [#imageLiteral(resourceName: "Image"), #imageLiteral(resourceName: "macBook")]

    @IBOutlet weak var imageSlider: ImageSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSlider.delegate = self
        imageSlider.reloadData()
    }

}

extension ProductDetailViewController: ImageSliderDataSource {
    
    func numberOfImages(in imageSlider: ImageSlider) -> Int {
        images.count
    }
    
    func imageSlider(_ imageSlider: ImageSlider, imageForPageAt page: Int) -> UIImage {
        images[page]
    }
    
}
