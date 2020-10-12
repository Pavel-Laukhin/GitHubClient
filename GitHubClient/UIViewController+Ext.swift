//
//  UIViewController+Ext.swift
//  GitHubClient
//
//  Created by Павел on 12.10.2020.
//

import UIKit

extension UIViewController {
    
    /// Cмещает клавиатуру в зависимости от размера экрана
    /// - Parameters:
    ///   - keyboardSize: размер клавиатуры
    func shiftView(_ keyboardSize: CGRect) {
        self.view.frame.origin.y = -keyboardSize.height
    }
}

// MARK: ViewController Notification
extension UIViewController {
    
    /// сообщает что клавиатура появилась
    /// - Parameter keyboardWillShownSelector: необходимо передать метод в селектор, отвечающий за появление клавиатуры
    func notificationAddObserver(_ keyboardWillShownSelector: Selector) {
        NotificationCenter.default.addObserver(self,
                                               selector: keyboardWillShownSelector,
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    /// метод вызывается когда клавиатура скрывается
    @objc
    func keyboardWillHide() {
        self.view.frame.origin.y = .zero
    }
}
