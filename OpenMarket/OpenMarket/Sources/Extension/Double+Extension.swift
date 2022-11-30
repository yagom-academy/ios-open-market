//
//  OpenMarket - Double+Extension.swift
//  Created by Zhilly, Dragon. 22/11/25
//  Copyright © yagom. All rights reserved.
//

import UIKit

extension Double {
    func convertNumberFormat() -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
       
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(for: self) ?? String()
    }
}
