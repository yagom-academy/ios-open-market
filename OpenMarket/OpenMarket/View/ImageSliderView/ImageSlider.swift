//
//  ImageSlider.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/25.
//

import UIKit

class ImageSlider: UIView {
    weak var delegate: ImageSliderDataSource?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let xibName = "ImageSlider"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
        scrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadNib()
        scrollView.delegate = self
        scrollView.frame = self.frame
    }
    
    func reloadData() {
        updateUI()
    }
    
    private func loadNib() {
        let nib = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        guard let view = nib?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func updateUI() {
        guard let count = delegate?.numberOfImages(in: self) else { return }
        
//        scrollView.frame = self.frame
        scrollView.contentSize.width = scrollView.frame.width * CGFloat(count)
        
        (0..<count).forEach { index in
            let currentXPosition = scrollView.frame.width * CGFloat(index)
            let imageView = UIImageView()
            let origin = CGPoint(x: currentXPosition, y: 0)
            let size = CGSize(width: self.frame.width, height: self.frame.height)
            imageView.frame = CGRect(origin: origin, size: size)
            imageView.image = delegate?.imageSlider(self, imageForPageAt: index)
            scrollView.addSubview(imageView)
        }
        updateNumberOfPages()
    }
    
    private func updateNumberOfPages() {
        guard let count = delegate?.numberOfImages(in: self) else { return }
        pageControl.numberOfPages = count
    }
    
    private func updateCurrentPages(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
    
}

extension ImageSlider: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / self.frame.width
        updateCurrentPages(currentPage: Int(round(value)))
    }
    
}

protocol ImageSliderDataSource: AnyObject {
    
    func numberOfImages(in imageSlider: ImageSlider) -> Int
    func imageSlider(_ imageSlider: ImageSlider, imageForPageAt page: Int) -> UIImage
    
}
