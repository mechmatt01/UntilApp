//
//  EventPageViewController.swift
//  UntilApp
//
//  Created by Spencer Paciello on 8/12/20.
//

import UIKit

class EventPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var allViewControllers: [UIViewController] = []
    var pageControl = UIPageControl()

    func configurePageControl() {
           // The total number of pages that are available is based on how many available colors we have.
           pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
           self.pageControl.numberOfPages = allViewControllers.count
           self.pageControl.currentPage = 0
           self.pageControl.tintColor = UIColor.black
           self.pageControl.pageIndicatorTintColor = UIColor.white
           self.pageControl.currentPageIndicatorTintColor = UIColor.black
           self.view.addSubview(pageControl)
       }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = allViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return allViewControllers.last
        }
        
        guard allViewControllers.count > previousIndex else {
            return nil
        }
        
        return allViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = allViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = allViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return allViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return allViewControllers[nextIndex]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self;
        
    
        dataSource = self
        for event in loadEvents()! {
            let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
            pageContentViewController.event = event;
            pageContentViewController.preloadView()
            
            allViewControllers.append(pageContentViewController)
        }
        
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        pageContentViewController.event = loadEvents()![0];
        
        if let firstViewController = allViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        configurePageControl()

        // Do any additional setup after loading the view.
    }
    

    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return loadEvents()!.count;
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = allViewControllers.firstIndex(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
    private func loadEvents() -> [Event]? {
        do {
            let rawData = try Data(contentsOf: Event.ArchiveURL)
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawData) as? [Event]
        } catch {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = allViewControllers.firstIndex(of: pageContentViewController)!
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    
    func preloadView() {
        let _ = view
    }
}
