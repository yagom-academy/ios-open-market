//
//  AlertSetting.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

enum AlertSetting {
    case controller
    case confirmAction
    case cancelAction
    case modifyAction
    case deleteAction
    
    var title: String {
        switch self {
        case .controller:
            return "알림"
        case .confirmAction:
            return "확인"
        case .cancelAction:
            return "취소"
        case .modifyAction:
            return "수정"
        case .deleteAction:
            return "삭제"
        }
    }
}
