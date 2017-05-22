//
//  WalthroughPageViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 5/9/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    
    var pageImages = ["1.NoMyIssueguide", "2.NoMyIssueguide", "3.NoMyIssueguide"]

    var pageControl:UIPageControl?
    var forwardButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the data source to itself
        dataSource = self
        delegate = self
        
        // Create the first walkthrough screen
        if let startingViewController = viewControllerAtIndex(0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(_ index: Int) -> WalkthroughContentViewController? {
        
        if index == NSNotFound || index < 0 || index >= pageImages.count {
        return nil
        }
        
        // Create a new view controller and pass suitable data.
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
        
            pageContentViewController.imageFile = pageImages[index]
           
            pageContentViewController.index = index
        
            return pageContentViewController
        }
        
        return nil
    }

    func forward(_ index:Int) {
        if let nextViewController = viewControllerAtIndex(index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {
            return
        }
        
        if let viewControllers = pageViewController.viewControllers,
            let currentViewController = viewControllers[0] as? WalkthroughContentViewController {
            
            pageControl?.currentPage = currentViewController.index
            let buttonTitle = (pageControl?.currentPage == 2) ? "DONE" : "NEXT"
            forwardButton?.setTitle(buttonTitle, for: UIControlState())
        }
    }
    
    
    // For default page indicator
    /*
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageHeadings.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughContentViewController") as? WalkthroughContentViewController {
        
            return pageContentViewController.index
        }
        
        return 0
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
