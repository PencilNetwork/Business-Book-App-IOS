//
//  ViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/5/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var shipImg: UIImageView!
    @IBOutlet weak var seaImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//         if UserDefaults.standard.value(forKey: "logout") as? Bool == true {
//            performSegue(withIdentifier: "showNavigation", sender: self)
//         }else{
//            perform(#selector(showNavigation),with:nil,afterDelay:2)
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
         self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UserDefaults.standard.value(forKey: "logout") as? Bool == true {
            performSegue(withIdentifier: "showNavigation", sender: self)
        }else{
            perform(#selector(showNavigation),with:nil,afterDelay:2)
        }
       self.shipImg.alpha = 0
      
//        UIView.animate(withDuration: 4, delay: 0.08, options: [.repeat, .curveLinear], animations: {
//            //            self.shipImg.frame.origin.x = +self.shipImg.frame.width
//            self.shipImg.frame = self.shipImg.frame.offsetBy(dx: 1 * self.shipImg.frame.size.width, dy: 0.0)
//        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      UIView.animate(withDuration: 2, animations: {
          self.shipImg.alpha = 1
        

        })
//        UIView.animate(withDuration: 2.0, animations: {() -> Void in
//      self.shipImg.transform = CGAffineTransform(scaleX: 0.51, y: 0.51)
//        }, completion: {(_ finished: Bool) -> Void in
//            UIView.animate(withDuration: 2.0, animations: {() -> Void in
//               self.shipImg.transform = CGAffineTransform(scaleX: 1, y: 1)
//            })
//        })
//        let toImage = UIImage(named:"ship.png")
//        UIView.transition(with: self.shipImg,
//                          duration:5,
//                          options: .transitionCrossDissolve,
//                          animations: { self.shipImg.image = toImage },
//                          completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func showNavigation(){
    
         if UserDefaults.standard.value(forKey: "Login") as? Bool == true {
            if UserDefaults.standard.value(forKey: "LoginEnter") as? Bool == false || UserDefaults.standard.value(forKey: "LoginEnter")  == nil {//logout
              performSegue(withIdentifier: "showNavigation", sender: self)
            }else{
                if UserDefaults.standard.value(forKey: "userType") as? String == "Business"{
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileViewController") as! BusinessProfileViewController

                    self.navigationController?.pushViewController(viewController, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserLeftMenuVC") as? UserLeftMenuVC
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
         }else{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
            
            self.present(newViewController, animated: false, completion: nil)
        }
        
    }
   
}

