//
//  AlertDirector.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/20.
//

import UIKit

final class AlertDirector {
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func createErrorAlert(message: String) {
        AlertBuilder(viewController: viewController)
            .setTitle("에러 발생")
            .setMessage(message)
            .setOkButton()
            .show()
    }
    
    func createImageSelectActionSheet(albumAction: @escaping (UIAlertAction) -> Void, cameraAction: @escaping (UIAlertAction) -> Void) {
        AlertBuilder(viewController: viewController)
            .setAlertStyle(.actionSheet)
            .setFirstActionTitle("앨범")
            .setFirstAction(albumAction)
            .setSecondActionTitle("카메라")
            .setSecondAction(cameraAction)
            .setCancelButton()
            .show()
    }
    
    func createProductEditActionSheet(editAction: @escaping (UIAlertAction) -> Void, deleteAction: @escaping (UIAlertAction) -> Void) {
        AlertBuilder(viewController: viewController)
            .setAlertStyle(.actionSheet)
            .setFirstActionTitle("수정")
            .setFirstAction(editAction)
            .setSecondActionTitle("삭제")
            .setSecondAction(deleteAction)
            .setSecondActionStyle(.destructive)
            .setCancelButton()
            .show()
    }
}
