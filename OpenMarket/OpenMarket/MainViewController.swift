//
//  MainViewController.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/14.
//
/*
 1. 세그
 2. 테이블뷰컨트롤러 설정
 3. 콜렉션뷰 설정
 */
import UIKit

class MainViewController: UIViewController {
    // MARK: - Properties
    private var shouldHideFirstView: Bool? {
        didSet {
            guard let shouldHideFirstView = shouldHideFirstView else { return }
            self.firstView.isHidden = shouldHideFirstView
            self.secondView.isHidden = !shouldHideFirstView
        }
    }
    
    private let segmentController: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["Table", "Grid"])
        segmentController.translatesAutoresizingMaskIntoConstraints = true
        segmentController.selectedSegmentIndex = 0
        return segmentController
    }()
    
    private let firstView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    private let secondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        addUIComponents()
        configurateLayout()
        setupSegment()
    }
    
    private func addUIComponents() {
        self.navigationItem.titleView = segmentController
        self.view.addSubview(firstView)
        self.view.addSubview(secondView)
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        self.shouldHideFirstView = segment.selectedSegmentIndex != 0
    }
    
    private func configurateLayout() {
        NSLayoutConstraint.activate([
            self.firstView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.firstView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            self.firstView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.firstView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            self.secondView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.secondView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            self.secondView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.secondView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupSegment() {
        didChangeValue(segment: self.segmentController)
        self.segmentController.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
    }
}
