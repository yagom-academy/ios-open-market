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
            .setPreferredStyle(.actionSheet)
            .setFirstActionTitle("앨범")
            .setSecondActionTitle("카메라")
            .setFirstAction(albumAction)
            .setSecondAction(cameraAction)
            .setCancelButton()
            .show()
    }
}
