//
//  MemeCreatorViewController.swift
//  MemeMe 2.0
//
//  Created by Andrew Olson on 7/15/16.
//  Copyright © 2016 Andrew Olson. All rights reserved.
//

import UIKit

class MemeCreatorViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate
{
    @IBOutlet weak var shareNavBarButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraToolBarButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //if the edit conditions are nill, then set up as normal else Edit
        
        setTextFieldAttributes(topTextField, text: "TOP")
        setTextFieldAttributes(bottomTextField, text: "BOTTOM")
    }

    override func viewWillAppear(animated: Bool) {
        subscribeToKeyboardNotifications()
        cameraToolBarButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        if imagePickerView.image == nil
        {
            shareNavBarButton.enabled = false
        }
        else
        {
            shareNavBarButton.enabled = true
        }
    }
    override func viewWillDisappear(animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    
    /* Mark: Button Actions */
    
    @IBAction func shareAction(sender: AnyObject)
    {
        let memeImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            if completed
            {
                //Save the image
                self.save()
                //Dismiss the view controller
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        presentViewController(activityViewController, animated: true, completion: nil)
    }
  
    @IBAction func cancelAction(sender: AnyObject)
    {
        //dismiss this view, and reviel the bottom one
         dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func albumAction(sender: AnyObject)
    {
        imagePickerControllerView(.PhotoLibrary)
        
    }
    @IBAction func cameraAction(sender: AnyObject)
    {
        imagePickerControllerView(.Camera)
    }
    func imagePickerControllerView(sourceType: UIImagePickerControllerSourceType)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    /* Mark: Keyboard Functions */
    func getKeyboardHeight(notification: NSNotification)-> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //Subscribe to keyboard will show notifications and will hide notifications
    func subscribeToKeyboardNotifications()
    {
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "keyboardWillShow:",name: UIKeyboardWillShowNotification,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "keyboardWillHide:",name: UIKeyboardWillHideNotification,object: nil)
    }
    //Unsubscribe to the above notifications
    func unsubscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self,name: UIKeyboardWillShowNotification,object: nil)
         NSNotificationCenter.defaultCenter().removeObserver(self,name: UIKeyboardWillHideNotification,object: nil)
    }
    func keyboardWillShow(notification: NSNotification)
    {
        if (self.bottomTextField.isFirstResponder() && self.view.frame.origin.y == 0)
        {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    func keyboardWillHide(notification: NSNotification)
    {
        view.frame.origin.y = 0
    }
    /* Mark: TextField Delegate / Functions */
    func setTextFieldAttributes(textField: UITextField, text: String)
    {
        let memeTextAttribues = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 38)!,
            NSStrokeWidthAttributeName : -3
        ]

        textField.delegate = self
        textField.text = text
        textField.defaultTextAttributes = memeTextAttribues
        textField.textAlignment = .Center
    }
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if (textField.text == "TOP")
        {
            self.topTextField.text = ""
        }
        else if (textField.text == "BOTTOM")
        {
            self.bottomTextField.text = ""
        }
        
    }
    func textFieldDidEndEditing(textField: UITextField)
    {
        
    }
    //Return key functionality
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    /*Mark: imageView Delegate Methods*/
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Func to cancel selection
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*Mark: Meme Creation*/
    func generateMemedImage() -> UIImage
    {
        setVisability(true)
        
        //create an image context
        UIGraphicsBeginImageContext(view.frame.size)
        //takes a snapshot of the screen
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        //get the meme Image from UIGraphics
        let memeImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        setVisability(false)
        
        return memeImage
    }
    func setVisability(hidden: Bool)
    {
        self.toolBar.hidden = hidden
        self.navigationBar.hidden = hidden
    }
    func save() {
        let memeImage = generateMemedImage()
        //Create the meme
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, image: imagePickerView.image, memeImage: memeImage)
        //save and store on memes: [Meme] array
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        print("saved meme")
        
    }
}

