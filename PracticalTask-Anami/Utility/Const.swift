//
//  Const.swift
//  PracticalTask-Anami
//
//  Created by Anami on 29/09/21.
//

import Foundation

//MARK:- API Constants
struct APIRequest {
    static let PrefixBaseUrl = "https://limitless-helsinki-xcm9oeewu8ax.vapor-farm-c1.com/users/test/me"
}

//MARK: - Networking
struct Networking {
    static let KeyErrorMessage = "Something went wrong"
    static let KeyNoInternetMessage = "No Internet available"
}

//MARK: - Camera
struct ImagePicker {
    static let KeyChooseImage = "Choose Image"
    static let KeyCamera = "Camera"
    static let KeyGallery = "Gallery"
    static let KeyNevermind = "Nevermind"
    static let KeyWarning = "Warning"
    static let StrCameraWarning = "You don't a have camera"
    static let KeyCameraPermission = "This app would like to access your Camera"
    static let KeyPhotoLibraryPermission = "This app would like to access your Photo Library"
}

//MARK: - AlertButtonTitle
struct ButtonTitles {
    static let KeyOk = "Ok"
    static let KeyCancel = "Cancel"
    static let KeyYes = "Yes"
    static let KeyNo = "No"
    static let KeySettings = "Settings"
}

//MARK: - User Key
struct User {
    static let KeyImageURL = "image_url"
    static let KeyFirstName = "first_name"
    static let KeyBio = "bio"
    static let KeyLocation = "location"
    static let KeyGender = "gender"
    static let KeyBioPlaceholder = "Enter your bio"
}

//MARK: - General Messages Key
struct GeneralMessages {
    static let KeyEnterBio = "Please enter bio"
    static let KeyEnterFirstName = "Please enter first name"
    static let KeyEnterGender = "Please enter gender"
    static let KeyEnterLocation = "Please enter location"
    static let KeyUpdateProfileSuccessMessage = "Profile updated successfully"
}
