//
//  cellpro.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/14.
//

import Foundation
import UIKit

protocol cellpro: UICollectionViewCell {
  
  func insertCellData(image: UIImage, name: String, fixedPrice: String, bargainPrice: String , stock: String)

}
