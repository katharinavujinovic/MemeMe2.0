//
//  ViewController.swift
//  MemeMe
//
//  Created by Katharina Müllek on 04.11.20.
//

import UIKit

class EditorViewController: UIViewController {


    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bufferView: UIView!
    @IBOutlet weak var bottomTollbar: UIToolbar!
    
    var passedMeme: FinishedMeme?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        shareButton.isEnabled = false
        
        if passedMeme != nil {
            imageView.image = passedMeme?.originalImage
            topTextField.text = passedMeme?.topText
            bottomTextField.text = passedMeme?.bottomText
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMemeTextField(textField: topTextField)
        configureMemeTextField(textField: bottomTextField)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    let fontProperties = FontProperties()
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureMemeTextField(textField: UITextField) {
            textField.delegate = self
            textField.defaultTextAttributes = fontProperties.textAttributes
            textField.textAlignment = .center
        }
    
    
//MARK: - Generate Meme
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let items = [generateMemedImage()]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityController, animated: true)
        
        activityController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.save()
                return
            } else {
                print("error")
            }
    }
    }
        
    func save() {
        let meme = FinishedMeme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        isHidden(status: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        isHidden(status: false)
        return memedImage
    }
    
    func isHidden(status: Bool) {
        topToolbar.isHidden = status
        bufferView.isHidden = status
        bottomTollbar.isHidden = status
    }
    
    
//MARK: - KeyboardNotifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
//            bottomConstraint.constant = getKeyboardHeight(notification)
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide() {
//        bottomConstraint.constant = 45
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
            if let keyboardSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                return keyboardSize.height
            } else {
                return 0
                }
    }
    
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension EditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func albumButtonPressed(_ sender: UIBarButtonItem) {
        pickAnImage(sourceType: .photoLibrary)
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        pickAnImage(sourceType: .camera)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = chosenImage
            shareButton.isEnabled = true
        } else {
            print(K.text.imageError)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
}


//MARK: - UITextFieldDelegate
extension EditorViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == K.text.top || textField.text == K.text.bottom {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        keyboardWillHide()
        return true
    }
    
}
