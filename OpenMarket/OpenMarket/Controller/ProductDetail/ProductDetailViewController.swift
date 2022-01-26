//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/25.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    private let images = [#imageLiteral(resourceName: "Image"), #imageLiteral(resourceName: "macBook")]
    
    var product: Product?

    @IBOutlet private weak var imageSlider: ImageSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSlider.delegate = self
        imageSlider.reloadData()
        print(product)
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
