//
//  UserLoginViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/10/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SDWebImage
import FBSDKLoginKit
import Alamofire
import FBSDKCoreKit
class UserLoginViewController: UIViewController ,GIDSignInUIDelegate{

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var loginGoogleBtn: UIButton!
    @IBOutlet weak var loginFacebookBtn: UIButton!
    var email:String?
    var name:String?
    var id:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(deleteActivityIndicator(_:)), name: NSNotification.Name(rawValue: "deleteActivityIndi"), object: nil)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.white
           GIDSignIn.sharedInstance().uiDelegate = self
          NotificationCenter.default.addObserver(self, selector: #selector(putImage(_:)), name: NSNotification.Name(rawValue: "putName"), object: nil)
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        // Do any additional setup after loading the view.
        let lang = UserDefaults.standard.value(forKey: "lang") as!String
        if lang == "ar" {
            continueBtn.setTitle("continue".localized(lang: "ar"), for: .normal)
            loginFacebookBtn.setTitle("تسجيل الدخول facebook", for: .normal)
            loginGoogleBtn.setTitle("تسجيل الدخول google", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func deleteActivityIndicator(_ notification: NSNotification){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    @objc func putImage(_ notification: NSNotification){
        profileImg.isHidden = false
        nameView.isHidden = false
        lineView.isHidden = false
        loginGoogleBtn.isHidden = true
        loginFacebookBtn.isHidden = true
        continueBtn.isHidden = false
        
//        self.googleImg.isHidden = true
//        //googleButton.isHidden = true
//        signInButton.isHidden = true
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        if let dict = notification.userInfo as NSDictionary? {
            if let image = dict["image"] as? URL{
                self.profileImg.sd_setImage(with: image, placeholderImage: UIImage(named: "profile.jpg"))
                // do something with your image
            }
            if let name = dict["name"] as? String{
               nameLBL.text = name
                self.name = name 
            }
            if let email = dict["email"] as? String{
                self.email = email 
            }
            if let id = dict["id"] as? String{
                self.id = id
            }
            try GIDSignIn.sharedInstance().signOut()
        }
    }

    @IBAction func loginWithFaceBook(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            print("social token \(accessToken.tokenString)")
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
             
                
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
                let _ = request?.start(completionHandler: { (connection, result, error) in
                    guard let userInfo = result as? [String: Any] else { return } //handle the error
                    
                    //The url is nested 3 layers deep into the result so it's pretty messy
                    if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        //Download image from imageURL
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.continueBtn.isHidden = false
                        self.profileImg.isHidden = false
                        //  self.googleButton.isHidden = true
                        self.loginFacebookBtn.isHidden = true
                        self.loginGoogleBtn.isHidden = true
                       self.lineView.isHidden = false
                        self.nameView.isHidden = false
                        self.profileImg.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "profile.jpg"))
                      
                        
                        
                    }
                    if let name = userInfo["name"] as? String {
                        self.nameLBL.text = name
                        self.name = name
                        
                        if let id  = userInfo["id"] as? String{
                            print("id\(id)")
                            self.id = id
                           
                            if let email = userInfo["email"] as? String {
                               self.email = email
                            }
                           
                           
                            
                        }
                    }
               //     let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
                    
                    

                        FBSDKLoginManager().logOut()
                    FBSDKAccessToken.setCurrent(nil)
                    FBSDKProfile.setCurrent(nil)
            //      FBSDKLoginManager().logOut()
                    
                })
                // Present the main view
                //                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") {
                //                    UIApplication.shared.keyWindow?.rootViewController = viewController
                //
                //                  self.dismiss(animated: true, completion: nil)
                //                }
                
            })
            
        }
    }
    func logout(){
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    @IBAction func LoginWithGoogle(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
         GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        var parameter :[String:AnyObject] = [String:AnyObject]()
        parameter["name"] =  name! as AnyObject?
        parameter["social_id"] = id! as AnyObject?
        if email != nil  {
            parameter["email"] = email! as AnyObject?
        }
        parameter["token"] = "token" as  AnyObject?
        let url = Constant.baseURL + Constant.URISearcherlogin
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
                                
                                let alert = UIAlertController(title: "", message: "Internal error", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                        }
                        if let data  = datares["data"] as? [String:Any]{
                            UserDefaults.standard.set("user", forKey: "userType")
                            UserDefaults.standard.set(true, forKey: "LoginEnter")
                            if let id = data["id"] as? Int {
                                UserDefaults.standard.set("\(id)", forKey: "user_id")
                                if let interest = data["interest"] as? [String:Any]{
                                    UserDefaults.standard.set(true,forKey:"interest")
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserLeftMenuVC") as? UserLeftMenuVC
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                    
                                    //
                                }else{
                                      UserDefaults.standard.set(false,forKey:"interest")
                                    let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "InterestPopupViewController") as! InterestPopupViewController
                                    self.addChildViewController(popupVC)
                                    popupVC.view.frame = self.view.frame
                                    self.view.addSubview(popupVC.view)
                                }
//
                               
                            }
                            if let name = data["name"] as? String{
                                print(name)
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
