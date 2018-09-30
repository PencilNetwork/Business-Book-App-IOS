//
//  SignUpViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/13/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
class SignUpViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
       self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
         self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        passwordTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        userNameTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        emailTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func ConfirmBtnAction(_ sender: Any) {
        var valid = checkTxtField()
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
    
    //MARK:Function
    func sendData(){
//        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
//
//        self.navigationController?.pushViewController(viewController, animated: true)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        print("deviceToken\(delegate.deviceToKen )")
            var parameter :[String:AnyObject] = [String:AnyObject]()
         parameter["name"] =  userNameTxt.text! as AnyObject?
        parameter["email"] = emailTxt.text! as AnyObject?
        parameter["password"] = passwordTxt.text! as  AnyObject?
     parameter["token"] = "token" as  AnyObject?
        Alamofire.request(Constant.baseURL + "owner/signup", method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let data = datares["data"]   as? [String:Any]{
                            if let id = data["owner_id"] as? Int {
                             UserDefaults.standard.setValue(id, forKey: "ownerId")
                                if let name = data["name"] as? String {
                                    self.view.removeFromSuperview()
                                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                                    viewController.id = id
                                    viewController.name = name
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
                       
                            }
                        }
                        if let flag = datares["flag"] as? String{
                            if flag == "0" {
                                if let errors = datares["errors"] as? [String:Any]{
                                    if let name = errors["name"] as? [String]{
                                        let alert = UIAlertController(title: "", message: name[0] as! String, preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    if let email = errors["email"] as? [String]{
                                        let alert = UIAlertController(title: "", message: email[0] as! String, preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    if let token = errors["token"] as? [String]{
                                        let alert = UIAlertController(title: "", message: token[0] as! String, preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                              
                            }
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "", message: error.localizedDescription as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    func checkTxtField()->Bool{
        var validFlag = true
        if userNameTxt.text == "" {
            validFlag = false
            userNameTxt.backgroundColor = .red
        }
        if passwordTxt.text == "" {
            validFlag = false
            passwordTxt.backgroundColor = .red
        }else{
            if (passwordTxt.text?.count)! < 6{
                validFlag = false
                let alert = UIAlertController(title: "alert", message: "Password should not less than 6 character", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        if emailTxt.text ==  "" {
            validFlag = false
            emailTxt.backgroundColor = .red
        }else{
            if isValidEmail(testStr: emailTxt.text!) == false{
                validFlag = false
                let alert = UIAlertController(title: "Warning", message: "InValid Email", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        return validFlag
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
