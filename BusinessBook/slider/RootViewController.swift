//
//  RootViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/5/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class RootViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    lazy var orderdViewControllers:[UIViewController] = {
        return [self.newVC(viewContoller: "IntroViewController"),self.newVC(viewContoller: "Intro1ViewController"),self.newVC(viewContoller: "Intro2ViewController"),self.newVC(viewContoller: "Intro3ViewController")]
    }()
    var pageControl = UIPageControl()
    var currentIndex: Int?
    private var pendingIndex: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
  UserDefaults.standard.set(true, forKey: "Login")
        self.dataSource = self
        if let firstViewController = orderdViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        self.delegate = self
        
        configurePageControl()
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
    //MARK:FUNCTION
    func configurePageControl(){
        pageControl = UIPageControl(frame: CGRect(x:0,y:UIScreen.main.bounds.maxY - 50,width:UIScreen.main.bounds.width,height:50))
        pageControl.numberOfPages = orderdViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.blue
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        self.view.addSubview(pageControl)
    }
    
    func newVC(viewContoller:String)->UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewContoller)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderdViewControllers.index(of: viewController)else{
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard orderdViewControllers.count != nextIndex else{
            //  return orderdViewControllers.first
            return nil
        }
        guard orderdViewControllers.count > nextIndex else{
            return nil
        }
        return orderdViewControllers[nextIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderdViewControllers.index(of: viewController)else{
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else{
            //  return orderdViewControllers.last
            return nil
        }
        guard orderdViewControllers.count > previousIndex else{
            return nil
        }
        return orderdViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        if let vc = orderdViewControllers.index(of: pageContentViewController)  {
            self.pageControl.currentPage = orderdViewControllers.index(of: pageContentViewController)!
        }
    }
    
}
