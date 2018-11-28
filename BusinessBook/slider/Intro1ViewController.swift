//
//  Intro1ViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/5/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class Intro1ViewController: UIViewController {
var pageViewController: RootViewController!
    lazy var orderdViewControllers:[UIViewController] = {
        return [self.newVC(viewContoller: "Intro1ViewController"),self.newVC(viewContoller: "Intro2ViewController"),self.newVC(viewContoller: "Intro3ViewController")]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
         
         self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let parentVC = self.parent as! RootViewController
        parentVC.pageControl.currentPage = 1
    }

    @IBAction func skipBtnAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FirstNavigationController")
        
        self.present(newViewController, animated: false, completion: nil)
        
    }
    


    
    
    func newVC(viewContoller:String)->UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewContoller)
    }
    
   
    
    @IBAction func nextBTnAction(_ sender: UIButton) {
        let parentVC = self.parent as! RootViewController
        
        parentVC.setViewControllers([parentVC.orderdViewControllers[2]], direction: .forward, animated: true, completion: nil)
    }
    
    
}
