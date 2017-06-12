//
//  ViewController.swift
//  memeMe
//
//  Created by Qichao Wang on 2017/6/8.
//  Copyright © 2017年 Qichao Wang. All rights reserved.
//
import Foundation
import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let memeTextAttributes:[String: Any]=[
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:40)!,
        NSStrokeWidthAttributeName: 10.0,
    ]
    
    let textFieldDelegate = textDelegate()
    
    @IBOutlet weak var options: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var botToolbar: UIToolbar!
    @IBOutlet weak var botText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickImage: UIBarButtonItem!
    @IBOutlet weak var cameraImage: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topText.defaultTextAttributes = self.memeTextAttributes
        self.botText.defaultTextAttributes = self.memeTextAttributes
        
        self.topText.textAlignment = NSTextAlignment.center
        self.botText.textAlignment = NSTextAlignment.center
        
        self.topText.delegate = self.textFieldDelegate
        self.botText.delegate = self.textFieldDelegate
        
        self.options.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cameraImage.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyBoardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeToKeyBoardNotification()
    }
    
    @IBAction func optionMenu(_ sender: Any){
        let generated = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [generated], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            
            if(success) {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
    
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(_ sender: Any){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraImage(_ sender: Any){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            options.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    func keyboardWillShow(_ notification: Notification){
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyBoardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyBoardNotification(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func save() {
        // Create the meme
        let meme = Meme(top: topText.text!, bot: botText.text!, original: imageView.image!, memed: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        setToolbarHidden(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        setToolbarHidden(false)
        
        return memedImage
    }
    
    func setToolbarHidden(_ isHidden:Bool){
        topToolbar.isHidden = isHidden
        botToolbar.isHidden = isHidden
    }

    
}

