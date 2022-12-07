//
//  OpenMarket - NetworkPatchable.swift
//  Created by Zhilly, Dragon. 22/12/01
//  Copyright © yagom. All rights reserved.
//

import Foundation

protocol NetworkPatchable {
    func patch(to url: URL?, params: ParamsProduct, completion: @escaping (Data) -> Void)
}
