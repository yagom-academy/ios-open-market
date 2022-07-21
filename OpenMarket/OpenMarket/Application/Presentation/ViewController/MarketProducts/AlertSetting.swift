//
//  AlertSetting.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/21.
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
