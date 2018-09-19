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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    //MARK:Variable
    var checkFlag:Bool = false
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
        Alamofire.request("https://pencilnetwork.com/bussines_book/api/owner/login", method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
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
                            if let bussines = data["bussines"] as?[Dictionary<String,Any>]{
                                if let id = bussines[0]["id"] as? Int{
                                    UserDefaults.standard.setValue(id, forKey: "id")
                                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileViewController") as! BusinessProfileViewController
                                    
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
                            }
                            if let owner_Id = data["owner_id"] as? Int {
                                UserDefaults.standard.setValue(owner_Id, forKey: "ownerId")
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