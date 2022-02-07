//
//  ProductImageDetailViewController.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/27.
//

import UIKit

class ProductImageDetailViewController: UIViewController, ReuseIdentifying {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var pageControl: UIPageControl!
  
  var images: [UIImage]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addPinchGesture()
    setPanGesture()
    setUpImageView()
  }
  
  @IBAction func exitButtonDidTap(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  func addPinchGesture() {
    let pinch = UIPinchGestureRecognizer(target: self, action: #selector(doPinch(_:)))
    scrollView.addGestureRecognizer(pinch)
  }
  
  func setPanGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureDismiss(_:)))
    self.view.addGestureRecognizer(panGesture)
  }
  
  @objc func doPinch(_ pinch: UIPinchGestureRecognizer) {
    if pinch.state == .began || pinch.state == .changed {
      guard let view = pinch.view else {
        return
      }
      let pinchCenter = CGPoint(x: pinch.location(in: view).x - view.bounds.midX,
                                y: pinch.location(in: view).y - view.bounds.midY
      )
      let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
        .scaledBy(x: pinch.scale, y: pinch.scale)
        .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
      let currentScale = scrollView.frame.size.width / scrollView.bounds.size.width
      var newScale = currentScale*pinch.scale
      
      if newScale < 1 {
        newScale = 1
        let transform = CGAffineTransform(scaleX: newScale, y: newScale)
        scrollView.transform = transform
        pinch.scale = 1
      } else {
        view.transform = transform
        pinch.scale = 1
      }
    }
  }
  
  @objc func panGestureDismiss(_ sender: UIPanGestureRecognizer) {
    var initialTouchPoint = CGPoint(x: 0, y: 0)
    let touchPoint = sender.location(in: view.window)
    
    switch sender.state {
    case .began:
      initialTouchPoint = touchPoint
    case .changed:
      if touchPoint.y - initialTouchPoint.y > 0 {
        view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: view.frame.width, height: view.frame.height)
      }
    case .ended, .cancelled:
      if touchPoint.y - initialTouchPoint.y > 300 {
        self.dismiss(animated: true, completion: nil)
      } else {
        UIView.animate(withDuration: 0.3) {
          self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
      }
    default:
      return
    }
  }
  
  func setUpImageView() {
    guard let imageCount = images?.count else {
      return
    }
    setUpImagePageControl(imageCount: imageCount)
    setUpScrollView(imageCount: imageCount)
    insertImageAtScrollView()
  }
  
  func setUpImagePageControl(imageCount: Int) {
    pageControl.currentPage = 0
    pageControl.numberOfPages = imageCount
  }
  
  func setUpScrollView(imageCount: Int) {
    scrollView.contentSize = CGSize(
      width: 	UIScreen.main.bounds.width * CGFloat(imageCount),
      height: UIScreen.main.bounds.width
    )
  }
  
  func insertImageAtScrollView() {
    guard let images = images else {
      return
    }
    for (index, image) in images.enumerated() {
      let imageView = UIImageView(image: image)
      imageView.isUserInteractionEnabled = true
      imageView.frame = CGRect(
        x: 0,
        y: (scrollView.bounds.height - scrollView.bounds.width) / 2,
        width: scrollView.bounds.width,
        height: scrollView.bounds.width
      )
      scrollView.addSubview(imageView)
      imageView.frame.origin.x = UIScreen.main.bounds.width * CGFloat(index)
    }
  }
}

extension ProductImageDetailViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
  }
}
