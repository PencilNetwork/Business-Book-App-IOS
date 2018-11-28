//
//  ForgetPasswordViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/10/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
         sendBtn.layer.cornerRadius = 10
        hideKeyboardWhenTappedAround()
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        // Do any additional setup after loading the view.
        email.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        let lang = UserDefaults.standard.value(forKey: "lang") as!String
        if lang == "ar" {
            email.placeholder = "email".localized(lang: "ar")
            sendBtn.setTitle("ابحث"
                , for: .normal)
            email.textAlignment = .right
        }else{
             email.textAlignment = .left
        }
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendAction(_ sender: Any) {
        var valid = checktxtField()
        if valid == true {
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            sendData()
            
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        }
    }
    func checktxtField()->Bool{
        var validFlag = true
        if email.text ==  "" {
            validFlag = false
            email.backgroundColor = .red
        }else{
            if isValidEmail(testStr: email.text!) == false{
                validFlag = false
                let alert = UIAlertController(title: "Warning", message: "InValid Email", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
       return validFlag
    }
    func sendData(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        var parameter :[String:AnyObject] = [String:AnyObject]()
        parameter["email"] =  email.text! as AnyObject?
        Alamofire.request(Constant.baseURL + "owner/mail", method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let flag = datares["flag"] as? String {
                            if flag == "0" {
                                if let errors = datares["errors"] as? String{
                                    let alert = UIAlertController(title: "", message: errors, preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }else{
                                    let alert = UIAlertController(title: "", message: "fail to send Password", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            }else{ //sucees
                                self.showToast(message: "success to send password")
                            }
                        }
                        
                        
                        
                    }
                case .failure(let error):
                    print(error)
                    
                    let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func textFieldDidChange(textField: UITextField){
        textField.backgroundColor = UIColor.white
    }
}
