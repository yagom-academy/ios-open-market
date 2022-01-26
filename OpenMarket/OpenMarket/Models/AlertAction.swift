import Foundation

enum AlertAction {
    case modify
    case delete
    case cancel
    case done
    
    var title: String {
        switch self {
        case .modify:
            return "수정"
        case .delete:
            return "삭제"
        case .cancel:
            return "취소"
        case .done:
            return "확인"
        }
    }
}
