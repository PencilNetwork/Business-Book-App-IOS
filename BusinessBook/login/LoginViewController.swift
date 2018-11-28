//
//  LoginViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/5/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
class LoginViewController: UIViewController {
 @IBOutlet weak var iconImg: UIButton!
    @IBOutlet weak var createnewBus: UIButton!
    @IBOutlet weak var forgetpasswordBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var rememberme: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    //MARK:Variable
    var checkFlag:Bool = false
    var iconClick = true
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
         self.navigationController?.navigationBar.topItem?.title = ""
         self.navigationController?.navigationBar.tintColor = UIColor.white
        hideKeyboardWhenTappedAround()
        passwordTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        usernameTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
       self.navigationItem.title = "Login"
        if (UserDefaults.standard.bool(forKey: "remember") as? Bool)! == true{
            usernameTxt.text = UserDefaults.standard.string(forKey: "username")
            passwordTxt.text = UserDefaults.standard.string(forKey: "password")
            checkBtn.setImage(UIImage(named:"greenCheckbox.png"), for: .normal)
        }
       let lang = UserDefaults.standard.value(forKey: "lang") as!String
        if lang == "ar" {
                containerView.semanticContentAttribute = .forceRightToLeft
                usernameTxt.textAlignment = .right
                passwordTxt.textAlignment = .right
            passwordTxt.placeholder = "password".localized(lang: "ar")
            usernameTxt.placeholder = "usernameorm".localized(lang: "ar")
            forgetpasswordBtn.setTitle("forgetPassword".localized(lang: "ar"), for: .normal)
            loginBtn.setTitle("login".localized(lang: "ar"), for: .normal)
            rememberme.text = "rememberme".localized(lang: "ar")
            rememberme.textAlignment = .right
            createnewBus.setTitle("createNewBus".localized(lang: "ar"), for: .normal)
        }else{
            containerView.semanticContentAttribute = .forceLeftToRight
            usernameTxt.textAlignment = .left
            passwordTxt.textAlignment = .left
            rememberme.textAlignment = .left
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:IBACTION
    @IBAction func checkBoxBtnAction(_ sender: Any) {
        checkFlag = !checkFlag
        if checkFlag == true {
            checkBtn.setImage(UIImage(named:"greenCheckbox.png"), for: .normal)
          
        }else{
    
            checkBtn.setImage(UIImage(named:"checkBox.png"), for: .normal)
        }
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        var valid = checkTxtField()
        if valid == true{
            if checkFlag == true {
                
                UserDefaults.standard.set(usernameTxt.text!, forKey: "username")
                UserDefaults.standard.set(passwordTxt.text!, forKey: "password")
                UserDefaults.standard.set(true, forKey: "remember")
            }else{
                UserDefaults.standard.set(false, forKey: "remember")
                
            }
            
            let network = Network()
            let networkExist = network.isConnectedToNetwork()
            
            if networkExist == true {
                sendData()
                
            }else{
                
                let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
//
        }
    }
    @IBAction func iconAction(sender: AnyObject) {
        if(iconClick == true) {
            passwordTxt.isSecureTextEntry = false
             iconImg.setImage(UIImage(named:"visibleeye.png"), for: .normal)
        } else {
            passwordTxt.isSecureTextEntry = true
             iconImg.setImage(UIImage(named:"invisibleeye.png"), for: .normal)
        }
        
        iconClick = !iconClick
    }
    @IBAction func createNewBusinessBtnAction(_ sender: Any) {
//        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
//
//        self.navigationController?.pushViewController(viewController, animated: true)
        let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.addChildViewController(popupVC)
        popupVC.view.frame = self.view.frame
        self.view.addSubview(popupVC.view)
//        viewController.providesPresentationContextTransitionStyle = true
//        viewController.definesPresentationContext = true
//        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        viewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//
//
//        self.present(viewController, animated: false)
        
    }
    
    
    @IBAction func forgetPassBtnAction(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func textFieldDidChange(textField: UITextField){
        textField.backgroundColor = UIColor.white
    }
    func checkTxtField()->Bool{
        var validFlag = true
        if usernameTxt.text == "" {
            validFlag = false
            usernameTxt.backgroundColor = .red
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
       
        return validFlag
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func sendData(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        var parameter :[String:AnyObject] = [String:AnyObject]()
        parameter["name"] =  usernameTxt.text! as AnyObject?
        parameter["password"] = passwordTxt.text! as AnyObject?
       
        parameter["token"] = "token" as  AnyObject?
        let url = Constant.baseURL + Constant.urILogin
        Alamofire.request(url, method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
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
                                }
                            }
                        }
                        if let data  = datares["data"] as? [String:Any]{
                            if let owner_Id = data["owner_id"] as? Int {
                                UserDefaults.standard.setValue(owner_Id, forKey: "ownerId")
                            }
                            if let bussines = data["bussines"] as? Dictionary<String,Any>{
                              UserDefaults.standard.set("Business", forKey: "userType")
                                UserDefaults.standard.set(true, forKey: "LoginEnter")
                                   if let id = bussines["id"] as? Int{
                                      UserDefaults.standard.setValue(id, forKey: "id")
                                      let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileViewController") as! BusinessProfileViewController
                                    
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                   }
                                
                            }else{ // no business
                                var ownerId = UserDefaults.standard.value(forKey: "ownerId") as! Int
                                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                                viewController.id = ownerId
                                
                                self.navigationController?.pushViewController(viewController, animated: true)
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
}
