//
//  ImageDetailViewController.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/25.
//

import UIKit

class ImageDetailViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    var images: [UIImage] = []
    var currentPage = 0
    
    lazy var zoomingTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        tap.numberOfTapsRequired = 2
        return tap
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpScrollView()
        setUpImageView()
        setUpButton()
    }
    
    @objc private func handleZoomingTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        zoom(point: location, animated: true)
    }
    
    private func zoom(point: CGPoint, animated: Bool) {
        let currectScale = scrollView.zoomScale
        let minScale = scrollView.minimumZoomScale
        let maxScale = scrollView.maximumZoomScale
        
        if minScale == maxScale, minScale > 1 {
            return
        }
        
        let toScale = maxScale
        let finalScale = currectScale == minScale ? toScale : minScale
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
    
    func setUpButton() {
        closeButton.setTitle("", for: .normal)
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
    
    private func setUpImageView() {
        imageView.image = images[currentPage]
        imageView.addGestureRecognizer(zoomingTap)
        imageView.isUserInteractionEnabled = true
    }
    
    func setUpImage(_ images: [UIImage], currentPage: Int) {
        self.images = images
        self.currentPage = currentPage
    }
    
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImageDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
