//
//  AlertImageViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/6/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class AlertImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 var pickerController = UIImagePickerController()
    var sendDelegate:SendImageDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
   self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        var image = info[UIImagePickerControllerEditedImage] as! UIImage
        dismiss(animated:true, completion: nil)
        self.dismiss(animated: false, completion:{()  in
            self.sendDelegate?.sendImage(image: image)
        })
    }
    @IBAction func CameraBtnAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            pickerController.delegate = self
            self.pickerController.sourceType = UIImagePickerControllerSourceType.camera
            pickerController.allowsEditing = true
            self .present(self.pickerController, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title:"Warning", message: "You Donot Have camera", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func GalleryBtnAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerController.allowsEditing = true
            
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
