//
//  IntroViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/13/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
   
    @IBAction func nextBtnAction(_ sender: Any) {
        let parentVC = self.parent as! RootViewController
        parentVC.setViewControllers([parentVC.orderdViewControllers[1]], direction: .forward, animated: true, completion: nil)
    }
    
    
    @IBAction func skipBtnAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FirstNavigationController")
        
        self.present(newViewController, animated: false, completion: nil)
    }
    
}
