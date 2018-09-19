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
        perform(#selector(showNavigation),with:nil,afterDelay:2)
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
            performSegue(withIdentifier: "showNavigation", sender: self)
         }else{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
            
            self.present(newViewController, animated: false, completion: nil)
        }
        
    }
   
}

