//
//  AlertSetting.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

enum AlertSetting {
    case controller
    case confirmAction
    
    var title: String {
        switch self {
        case .controller:
            return "알림"
        case .confirmAction:
            return "확인"
        }
    }
}
