//
//  Utility.swift
//  PracticalTask-Anami
//
//  Created by Anami on 29/09/21.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import SmartToast

@objc class Utility: NSObject {
    static let shared = Utility()
    
    var isCameraAllowed = false
    var isPhotoLibraryAllowed = false
    var dataCompressed = NSData()
    
    var rootViewController: UIViewController? = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
    
    // MARK:  Check camera permission 
    func requestCamera() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            Utility.shared.isCameraAllowed = true
        } else {
            if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        Utility.shared.isCameraAllowed = true
                    } else {
                        Utility.shared.isCameraAllowed = false
                    }
                }
            } else {
                self.rootViewController?.showAlert(title: "", message: ImagePicker.KeyCameraPermission, okBtnTitle: ButtonTitles.KeyCancel, cancelBtnTitle: ButtonTitles.KeySettings, okbuttonStyle: .default, okBtnCompletion: {
                }, cancelbtnCompletion: {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    }
                })
            }
        }
    }
    
    // MARK:  Check photo library permission 
    func requestPhotoLibrary() {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            Utility.shared.isPhotoLibraryAllowed = true
            NotificationCenter.default.post(name: NSNotification.Name("GalleryAllowed"), object: nil)
        } else {
            if PHPhotoLibrary.authorizationStatus() == .notDetermined {
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if (newStatus == PHAuthorizationStatus.authorized) {
                        Utility.shared.isPhotoLibraryAllowed = true
                        NotificationCenter.default.post(name: NSNotification.Name("GalleryAllowed"), object: nil)
                    } else {
                        Utility.shared.isPhotoLibraryAllowed = false
                    }
                })
            } else {
                self.rootViewController?.showAlert(title: "", message: ImagePicker.KeyPhotoLibraryPermission, okBtnTitle: ButtonTitles.KeyCancel, cancelBtnTitle: ButtonTitles.KeySettings, okbuttonStyle: .default, okBtnCompletion: {
                }, cancelbtnCompletion: {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    }
                })
            }
        }
    }
    
    func showToastMessage(message: String, duration: TimeInterval = 2.0, position: ToastPosition = .center) {
        ToastManager.showToast(message, duration: duration, position: position)
    }
}
