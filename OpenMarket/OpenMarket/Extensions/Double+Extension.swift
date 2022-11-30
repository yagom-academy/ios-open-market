//  Created by Aejong, Tottale on 2022/11/22.

import Foundation

extension Double {
    
    var decimalInt: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let formattedString = formatter.string(from: self as NSNumber) else { return "" }
        
        return formattedString
    }
}
