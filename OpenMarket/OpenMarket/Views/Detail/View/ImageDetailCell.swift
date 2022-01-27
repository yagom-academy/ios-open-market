//
//  ImageDetailCell.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/25.
//

import UIKit

class ImageDetailCell: UICollectionViewCell {
    
    static let identifier = "imageDetail"
    static let nibName = "ImageDetailCell"
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpScrollView()
        setUpImageView()
        scrollView.delegate = self
    }
    
    private func setUpImageView() {
        imageView.addGestureRecognizer(zoomingTap)
        imageView.isUserInteractionEnabled = true
    }
    
    private func setUpScrollView() {
        scrollView.delegate = self
        scrollView.zoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
    }
    
    private lazy var zoomingTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        tap.numberOfTapsRequired = 2
        return tap
    }()
    
    @objc private func handleZoomingTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        zoom(point: location, animated: true)
    }
    
    private func zoom(point: CGPoint, animated: Bool) {
        let currectScale = scrollView.zoomScale
        let minScale = scrollView.minimumZoomScale
        let maxScale = scrollView.maximumZoomScale
        
        let finalScale = currectScale == minScale ? maxScale : minScale
        let zoomRect = zoomRect(scale: finalScale, center: point)
        scrollView.zoom(to: zoomRect, animated: animated)
    }
    
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = scrollView.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }

}

extension ImageDetailCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
