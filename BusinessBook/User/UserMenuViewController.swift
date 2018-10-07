//
//  UserMenuViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/25/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class UserMenuViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
  var menuList = ["Home","All categories","OFFERS","YOUR FAVOURITE BUSINESS","EDIT YOUR default search","LOGOUT"]
    
    @IBOutlet weak var menuTableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuTableView: UITableView!
    var menuDel:menuDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
         menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.tableFooterView = UIView()
        menuTableView.backgroundColor = UIColor.gray
        if UIDevice.isIphoneX { // it is iphone x or iphonesx or xs max
            menuTableTopConstraint.constant = 24
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuUserTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.menuItem.text = menuList[indexPath.row]
        cell.backgroundColor = UIColor.gray
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if  indexPath.row == 2 || indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 0 || indexPath.row == 4{
            menuDel?.menuActionDelegate(number: indexPath.row)
            self.view.removeFromSuperview()
        }else if  indexPath.row == 5{
            self.view.removeFromSuperview()
            UserDefaults.standard.set("", forKey: "userType")
            UserDefaults.standard.set(false, forKey: "LoginEnter")
            UserDefaults.standard.set(true,forKey: "logout")
            AppDelegate.userMenu_bool = true
            self.navigationController?.popToRootViewController( animated: false )
//            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
//            for aViewController in viewControllers {
//                if aViewController is HomeViewController {
//                    UserDefaults.standard.set("", forKey: "userType")
//                    UserDefaults.standard.set(false, forKey: "LoginEnter")
//                    self.navigationController!.popToViewController(aViewController, animated: true)
//                }
//            }
        }
       
    }
}
