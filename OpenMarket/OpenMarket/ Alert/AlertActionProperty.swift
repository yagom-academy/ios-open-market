//
//  AlertActionProperty.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/20.
//

import UIKit

struct AlertActionProperty {
    var title: String?
    var alertActionStyle: UIAlertAction.Style = .default
    var action: ((UIAlertAction) -> Void)?
}
