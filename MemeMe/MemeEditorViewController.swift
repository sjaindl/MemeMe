//
//  ViewController.swift
//  MemeMe
//
//  Created by Stefan Jaindl on 30.03.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    
    @IBOutlet weak var textTopTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var textBottomBottomConstraint: NSLayoutConstraint!
    
    var memeTextFieldDelegate: MemeTextFieldDelegate?
    var meme: Meme?
    
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage?
        var memeImage: UIImage?
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotification(withName: .UIKeyboardDidShow, withSelector: #selector(keyboardWillShow(_:)))
        subscribeToNotification(withName: .UIKeyboardDidHide, withSelector: #selector(keyboardWillHide(_:)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        memeTextFieldDelegate = MemeTextFieldDelegate()
        prepareTextFields()
        setShareButtonEnabledState()
    }
    
    override func viewDidLayoutSubviews() {
        setTextFieldConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromNotification(withName: .UIKeyboardDidShow)
        unsubscribeFromNotification(withName: .UIKeyboardDidHide)
    }
    
    func prepareTextFields() {
        prepareTextField(textTop, withText: MemeText.topText)
        prepareTextField(textBottom, withText: MemeText.bottomText)
    }
    
    func prepareTextField(_ textField: UITextField, withText text: String) {
        textField.text = text
        textField.textAlignment = .center
        textField.defaultTextAttributes = MemeText.textFieldDefaultAttributes
        textField.delegate = memeTextFieldDelegate
    }

    @IBAction func share(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        
        if let memedImage = memedImage {
            let shareController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            shareController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
               self.saveMeme()
            }
            
            shareController.popoverPresentationController?.sourceView = self.view
            present(shareController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        imageView.image = nil
        textTop.text = MemeText.topText
        textBottom.text = MemeText.bottomText
        setShareButtonEnabledState()
    }
    
    @IBAction func takePhotoFromCamera(_ sender: UIBarButtonItem) {
        showPicker(withType: .camera)
    }
    
    @IBAction func selectPhotoFromAlbum(_ sender: UIBarButtonItem) {
        showPicker(withType: .photoLibrary)
    }
    
    func showPicker(withType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = withType
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = originalImage
        }
        
        setShareButtonEnabledState()
    }
    
    func setTextFieldConstraints() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            let rect = self.calculateRectOfImageInImageView(imageView: self.imageView)
            
            if rect.origin.y != 0.0 {
                self.textTopTopConstraint.constant = rect.origin.y - 16
                self.textBottomBottomConstraint.constant = -rect.origin.y + 16
            }
        })
    }
    
    //helper method: credits to https://stackoverflow.com/questions/26348736/uiimageview-get-the-position-of-the-showing-image
    func calculateRectOfImageInImageView(imageView: UIImageView) -> CGRect {
        let imageViewSize = imageView.frame.size
        let imgSize = imageView.image?.size
        
        guard let imageSize = imgSize, imgSize != nil else {
            return CGRect.zero
        }
        
        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHeight)
        
        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
        // Center image
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2
        
        // Add imageView offset
        imageRect.origin.x += imageView.frame.origin.x
        imageRect.origin.y += imageView.frame.origin.y
        
        return imageRect
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func subscribeToNotification(withName notificationName: NSNotification.Name, withSelector notificationSelector: Selector) {
        NotificationCenter.default.addObserver(self, selector: notificationSelector, name: notificationName, object: nil)
    }
    
    func unsubscribeFromNotification(withName notificationName: NSNotification.Name) {
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification : Notification) {
        if memeTextFieldDelegate!.currentTextField?.tag == MemeText.bottomTag {
            view.frame.origin.y = -getKeyboardHeigth(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification : Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeigth(_ notification : Notification) -> CGFloat {
        let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func saveMeme() {
        if let originalImage = imageView?.image {
            self.meme = Meme(topText: textTop!.text!, bottomText: textBottom!.text!, originalImage: originalImage, memeImage: generateMemedImage())
            dismiss(animated: true, completion: nil)
            
            UIImageWriteToSavedPhotosAlbum(meme!.memeImage!, nil, nil, nil)
        }
    }
    
    func generateMemedImage() -> UIImage? {
        //Hide toolbar/navbar for mimed image
        hideBars(true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Restore toolbar/navbar
        hideBars(false)
        
        return memedImage
    }
    
    func hideBars(_ isHidden: Bool) {
        topBar.isHidden = isHidden
        bottomBar.isHidden = isHidden
    }
    
    func setShareButtonEnabledState() {
        let enable = imageView.image != nil
        shareButton.isEnabled = enable
    }
}
