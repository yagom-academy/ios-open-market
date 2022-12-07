//
//  OpenMarket - NetworkPostable.swift
//  Created by Zhilly, Dragon. 22/12/01
//  Copyright © yagom. All rights reserved.
//

import UIKit

protocol NetworkPostable {
    func post(to url: URL?, param: ParamsProduct, imageArray: [UIImage])
}
