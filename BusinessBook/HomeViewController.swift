//
//  HomeViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/5/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var langView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         UserDefaults.standard.set(false,forKey: "logout")
        let myimage = UIImage(named: "advertisment.png")?.withRenderingMode(.alwaysOriginal)
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
    }
    
    
    @IBAction func arabicBtnAction(_ sender: Any) {
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
