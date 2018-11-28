//
//  HomeViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/5/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var createYourBus: UIButton!
    
    @IBOutlet weak var searchForBusiness: UIButton!
    @IBOutlet weak var langView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         UserDefaults.standard.set("en", forKey: "lang")
         UserDefaults.standard.set(false,forKey: "logout")
        let myimage = UIImage(named: "menuLang.png")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem2 = UIBarButtonItem(image: myimage, style: .plain, target: self, action: #selector(ButtonTapped))
        self.navigationItem.rightBarButtonItem = barButtonItem2

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func ButtonTapped() {
        print("Button Tapped")
        langView.isHidden = !langView.isHidden
    }
   
    @IBAction func englishBtnAction(_ sender: Any) {
        langView.isHidden = true
        UserDefaults.standard.set("en", forKey: "lang")
        createYourBus.setTitle("Create your business profile", for: .normal)
        searchForBusiness.setTitle("Search for business", for: .normal)
    }
    
    
    @IBAction func arabicBtnAction(_ sender: Any) {
         langView.isHidden = true 
        UserDefaults.standard.set("ar", forKey: "lang")
        createYourBus.setTitle("createYourBus".localized(lang: "ar"), for: .normal)
        searchForBusiness.setTitle("searchForBus".localized(lang: "ar"), for: .normal)
    }
    

    @IBAction func createBusinessAction(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
       
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UserLoginViewController") as! UserLoginViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
extension String {
    func localized(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
