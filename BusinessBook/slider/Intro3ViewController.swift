//
//  Intro3ViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/5/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class Intro3ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let parentVC = self.parent as! RootViewController
        parentVC.pageControl.currentPage = 3
    }

    @IBAction func skipBtnAction(_ sender: Any) {
    }
    

//    @IBAction func GoToBtnAction(_ sender: Any) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//
//        self.present(newViewController, animated: false, completion: nil)
//    }
    
    @IBAction func gotoHome(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "FirstNavigationController") 
        
                self.present(newViewController, animated: false, completion: nil)
        
    }
}
