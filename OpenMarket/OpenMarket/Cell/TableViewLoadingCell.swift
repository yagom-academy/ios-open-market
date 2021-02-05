//
//  LoadingCell.swift
//  OpenMarket
//
//  Created by Yeon on 2021/02/04.
//

import Foundation
import UIKit

class LoadingCell: UITableViewCell {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    func start() {
        activityIndicatorView.startAnimating()
    }
}
