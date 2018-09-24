//
//  BusinessProfileViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/6/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
protocol menuDelegate{
    func menuActionDelegate(number:Int)
}
class BusinessProfileViewController: UIViewController ,menuDelegate{
    
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var menu_vc:MenuViewController!
    var EditBusinessProfileVC :EditBusinessProfileViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.layer.cornerRadius = 10
        
//        let myimage = UIImage(named: "search.png")?.withRenderingMode(.alwaysOriginal)
//        let menu = UIBarButtonItem(image: myimage, style: .plain, target: self, action: #selector(ButtonTapped))
//        self.navigationItem.leftBarButtonItem = menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
//        EditBusinessProfileVC =  self.storyboard?.instantiateViewController(withIdentifier: "EditBusinessProfileViewController") as! EditBusinessProfileViewController
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        // Do any additional setup after loading the view.
         NotificationCenter.default.addObserver(self, selector: #selector(returnToBusiness(_:)), name: NSNotification.Name(rawValue: "returnToBusiness"), object: nil)
    }
        //MARK:Function
    @objc func respondToGesture(gesture:UISwipeGestureRecognizer){
        switch gesture.direction{
        case UISwipeGestureRecognizerDirection.right:
            print("right")
            showMenu()
        case UISwipeGestureRecognizerDirection.left:
            print("left Swipe")
            close_on_swipe()
        default:
            print("")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func ButtonTapped() {
        print("Button Tapped")
        if  AppDelegate.menu_bool{
            showMenu()
        }else{
            closeMenu()
        }
    }
      @objc func returnToBusiness(_ notification: NSNotification){
        view1.isHidden = false
        view2.isHidden = true
        view3.isHidden = true
        view4.isHidden = true
        view5.isHidden = true
         segmentControl.selectedSegmentIndex = 0
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshOffer"), object: nil, userInfo: nil)
     }
    func close_on_swipe(){
        if  AppDelegate.menu_bool{
            
        }else{
            closeMenu()
        }
    }
    func showMenu(){
        UIView.animate(withDuration: 0.3){ ()->Void in
            self.menu_vc.view.frame = CGRect(x:0,y:60,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
            self.menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
           self.menu_vc.menuDel = self
            self.addChildViewController(self.menu_vc)
            self.view.addSubview(self.menu_vc.view)
            AppDelegate.menu_bool = false
        }
        
    }
    func closeMenu(){
        UIView.animate(withDuration: 0.3, animations: { ()->Void in
            self.menu_vc.view.frame = CGRect(x:-UIScreen.main.bounds.size.width,y:60,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        }) { (finished) in
            self.menu_vc.view.removeFromSuperview()
        }
        
        AppDelegate.menu_bool = true
    }
    func menuActionDelegate(number:Int){
        if number == 2{
           view3.isHidden = false
             view4.isHidden = true
            view5.isHidden = true
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: nil)
        }else if number == 1 { // addrelated files
            
            view4.isHidden = false
            view5.isHidden = true
            view3.isHidden = true
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deletefiles"), object: nil, userInfo: nil)
        }else if number == 3{
            view5.isHidden = false
             view3.isHidden = true
            view4.isHidden = true
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshPageOffer"), object: nil, userInfo: nil)
        }else if number == 0{
            view1.isHidden = false
            view2.isHidden = true
            view3.isHidden = true
            view4.isHidden = true
            view5.isHidden = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshOffer"), object: nil, userInfo: nil)
        }
    }
    @IBAction func menuBtnAction(_ sender: Any) {
        if  AppDelegate.menu_bool{
            showMenu()
        }else{
            closeMenu()
        }
    }
    
    @IBAction func segmentControlAction(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            view1.isHidden = false
            view2.isHidden = true
             view3.isHidden = true
           view4.isHidden = true
            view5.isHidden = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshOffer"), object: nil, userInfo: nil)
        case 1:
            view2.isHidden = false
            view1.isHidden = true
            view3.isHidden = true
            view4.isHidden = true
            view5.isHidden = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteCreateOffer"), object: nil, userInfo: nil)
        default:
            print("")
        }
    }
    
}
