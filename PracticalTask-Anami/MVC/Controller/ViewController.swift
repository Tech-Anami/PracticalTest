//
//  ViewController.swift
//  PracticalTask-Anami
//
//  Created by Anami on 29/09/21.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    // MARK: -  IBOutlets 
    @IBOutlet weak var viewImageSection: UIView!
    @IBOutlet weak var viewBioSection: UIView!
    @IBOutlet weak var viewInfoSection: UIView!
    
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var buttonChangePic: UIButton!
    
    @IBOutlet weak var labelBio: UILabel!
    @IBOutlet weak var textViewBio: UITextView!
    @IBOutlet weak var buttonEditBio: UIButton!
    @IBOutlet weak var buttonSaveBio: UIButton!
    @IBOutlet weak var constraintBioHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var stackViewLabels: UIStackView!
    @IBOutlet weak var stackViewTextFields: UIStackView!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldGender: UITextField!
    @IBOutlet weak var textFieldLocation: UITextField!
    
    // MARK: -  Variables 
    var userProfile: UserModel?
    fileprivate var imagePicker = UIImagePickerController()
    fileprivate var stringProfilePic = ""
    fileprivate var stringBio = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
}

// MARK: -  Custom Methods 
extension ViewController {
    func setupView() {
        viewImageSection.layer.cornerRadius = 10
        viewBioSection.layer.cornerRadius = 10
        viewInfoSection.layer.cornerRadius = 10
        
        imagePicker.delegate = self
        imageViewProfilePic.accessibilityIdentifier = ""
        
        stackViewLabels.isHidden = false
        stackViewTextFields.isHidden = true
        
        buttonEditBio.isHidden = false
        buttonSaveBio.isHidden = true
        
        labelBio.isHidden = false
        textViewBio.isHidden = true
        constraintBioHeight.constant = 0
        
        textViewBio.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textViewBio.tintColor = .black
        textViewBio.tintColorDidChange()
        
        callAPIGetBasicInfo()
    }
    
    // MARK: -  Set profile data in views 
    fileprivate func setProfileData(user: UserDataModel) {
        guard let profilePic = user.data?.image_url else { return }
        
        let url = URL(string: profilePic)
        
        self.imageViewProfilePic.kf.indicatorType = .activity
        self.imageViewProfilePic.kf.setImage(with: url, placeholder: UIImage(named: "userplaceholdericon"), options: [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ])
        
        self.stackViewLabels.isHidden = false
        self.stackViewTextFields.isHidden = true
        
        self.textFieldFirstName.text = user.data?.first_name
        self.textFieldGender.text = user.data?.gender
        self.textFieldLocation.text = user.data?.location
        
        self.labelFirstName.text = user.data?.first_name
        self.labelGender.text = user.data?.gender
        self.labelLocation.text = user.data?.location
        
        self.labelBio.isHidden = false
        self.textViewBio.isHidden = true
        self.constraintBioHeight.constant = 0
        
        self.stringBio = user.data?.bio ?? ""
        self.labelBio.text = self.stringBio
        self.textViewBio.text = self.stringBio
    }
    
    // MARK: -  Validation 
    fileprivate func validateData() -> Bool {
        guard let firstName = textFieldFirstName.text, !firstName.isEmpty else {
            Utility.shared.showToastMessage(message: GeneralMessages.KeyEnterFirstName, position: .bottom)
            return false
        }
        
        guard let gender = textFieldGender.text, !gender.isEmpty else {
            Utility.shared.showToastMessage(message: GeneralMessages.KeyEnterGender, position: .bottom)
            return false
        }
        
        guard let location = textFieldLocation.text, !location .isEmpty else {
            Utility.shared.showToastMessage(message: GeneralMessages.KeyEnterLocation, position: .bottom)
            return false
        }
        
        return true
    }
    
    // MARK: -  Base64 string 
    func convertImageToBase64String (image: UIImage) {
        stringProfilePic = image.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
}

// MARK:  Button Actions 
extension ViewController {
    @IBAction func buttonClickEditBio(_ sender: Any) {
        buttonEditBio.isHidden = true
        buttonSaveBio.isHidden = false
        
        labelBio.isHidden = true
        textViewBio.isHidden = false
        constraintBioHeight.constant = 150
    }
    
    @IBAction func buttonClickSaveBio(_ sender: Any) {
        callAPISaveBasicInfo()
    }
    
    @IBAction func buttonClickChangeProfilePic(_ sender: Any) {
        Utility.shared.requestCamera()
        Utility.shared.requestPhotoLibrary()
        
        if Utility.shared.isCameraAllowed && Utility.shared.isPhotoLibraryAllowed {
            let buttons = [ImagePicker.KeyCamera, ImagePicker.KeyGallery, ImagePicker.KeyNevermind]
            
            self.showAlert(title: ImagePicker.KeyChooseImage, msg: "", buttons: buttons, inViewController: self, style: .alert, sourceView: sender as? UIView) { (tag) in
                if tag == 0 {
                    if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                        self.imagePicker.sourceType = .camera
                        self.imagePicker.allowsEditing = true
                        self.present(self.imagePicker, animated: true, completion: nil)
                    } else {
                        Utility.shared.showToastMessage(message: ImagePicker.StrCameraWarning)
                    }
                } else if tag == 1 {
                    if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)) {
                        self.imagePicker.sourceType = .photoLibrary
                        self.imagePicker.mediaTypes = ["public.image"]
                        self.imagePicker.allowsEditing = true
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                } else {}
            }
        }
    }
    
    @IBAction func buttonClickSaveInfo(_ sender: Any) {
        if buttonEdit.titleLabel?.text == "EDIT" {
            stackViewLabels.isHidden = true
            stackViewTextFields.isHidden = false
            buttonEdit.setTitle("SAVE", for: .normal)
        } else {
            self.view.endEditing(true)
            guard validateData() else { return }
            callAPISaveBasicInfo()
        }
    }
}

//MARK: -  API Request / Response 
extension ViewController {
    //MARK: Get Basic Info
    fileprivate func callAPIGetBasicInfo() {
        let serviceManager = ServiceManager<UserModel>.init()
        
        serviceManager.MakeAPICall(httpMethod: .get, params: nil, loaderEnabled: true) { (Response) in
            let user = Response as? UserDataModel
            
            self.setProfileData(user: user!)
        }
    }
    
    //MARK: Save Basic Info
    fileprivate func callAPISaveBasicInfo() {
        let serviceManager = ServiceManager<UserModel>.init()
        
        let params = [User.KeyBio: self.stringBio, User.KeyFirstName: self.textFieldFirstName.text!, User.KeyGender: self.textFieldGender.text!, User.KeyLocation: self.textFieldLocation.text!]
        
        serviceManager.MakeAPICall(httpMethod: .put, params: params, loaderEnabled: true) { (Response) in
            let user = Response as? UserDataModel
            
            self.setProfileData(user: user!)
        }
    }
}

// MARK:  UITextFieldDelegate 
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldFirstName {
            textViewBio.becomeFirstResponder()
        } else if textField == textViewBio {
            textFieldLocation.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

// MARK:  UITextView Delegate 
extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        stringBio = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textViewBio.text.count <= 0 {
            stringBio = ""
        } else {
            stringBio = textViewBio.text
        }
    }
}

// MARK:  ImagePicker Delegate 
extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[.editedImage] as! UIImage
        
        self.imageViewProfilePic.image = tempImage
        self.convertImageToBase64String(image: self.imageViewProfilePic.image ?? UIImage())
        
        self.dismiss(animated: true, completion: nil)
        
        guard validateData() else { return }
        //callAPISaveBasicInfo()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
