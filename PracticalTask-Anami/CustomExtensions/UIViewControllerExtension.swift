//
//  UIViewControllerExtension.swift
//  PracticalTask-Anami
//
//  Created by Anami on 29/09/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, okBtnTitle:String, cancelBtnTitle:String? = ButtonTitles.KeyCancel, okbuttonStyle: UIAlertAction.Style, okBtnCompletion: @escaping () -> Void, cancelbtnCompletion : @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        
        alert.addAction(UIAlertAction(title: okBtnTitle, style: okbuttonStyle, handler: { _ in
            okBtnCompletion()
        }))
        
        if cancelBtnTitle != nil {
            alert.addAction(UIAlertAction(title: cancelBtnTitle, style: .default, handler: { (action) in
                cancelbtnCompletion()
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title:String?, msg:String?, buttons:[String], inViewController:UIViewController, style:UIAlertController.Style, sourceView:UIView?, handleClick:((_ indexClicked:Int) -> Void)?) {
        guard inViewController.presentedViewController == nil else { return }
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: style)
        
        if style == .actionSheet {
            alert.modalPresentationStyle = .popover
            
            if sourceView != nil {
                alert.popoverPresentationController?.sourceView = sourceView
                alert.popoverPresentationController?.sourceRect = sourceView!.bounds
            }
        }
        
        for idx in 0..<buttons.count {
            alert.addAction(UIAlertAction(title: buttons[idx], style: .default, handler: { (action:UIAlertAction) in
                guard handleClick != nil else { return }
                
                handleClick!(idx)
            }))
        }
        
        inViewController.present(alert, animated: true, completion: nil)
    }
}
