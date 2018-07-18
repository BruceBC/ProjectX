//
//  ImagePageViewController.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/13/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//
// Resource: https://medium.com/how-to-swift/how-to-create-a-uipageviewcontroller-a948047fb6af
// Miguel: ImageView.masksToBound = true // A lifesaver!

import UIKit

class ImagePageViewController: UIPageViewController {
    // MARK: - Properties
    lazy var pages = getPages()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        // Instaniate PageViewController
        setViewControllers([pages.first].compactMap { $0 }, direction: .forward, animated: false, completion: nil)
    }
}

extension ImagePageViewController {
    private func getPages() -> [ImageViewController] {
        return [#imageLiteral(resourceName: "trainGuy"), #imageLiteral(resourceName: "sunglassesGirl"), #imageLiteral(resourceName: "cityBoy"), #imageLiteral(resourceName: "uncomfortableGirl")]
            .map { ProfileViewModel(image: $0) }
            .compactMap { profile in
                guard let vc: ImageViewController = getViewController(withIdentifier: "ImageViewController") else { return nil }
                vc.profile = profile
                return vc
            }
    }
    
    private func getViewController<T>(withIdentifier identifier: String) -> T?
    {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as? T else { return nil }
        return vc
    }
}

extension ImagePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let imageViewController = viewController as? ImageViewController,
            let viewControllerIndex = pages.index(of: imageViewController)
        else { return nil }

        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0          else { return pages.last }
        guard pages.count > previousIndex else { return nil        }
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard
            let imageViewController = viewController as? ImageViewController,
            let viewControllerIndex = pages.index(of: imageViewController)
        else { return nil }

        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil         }
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard
            let imageViewController = pendingViewControllers.first as? ImageViewController,
            let pageIndex = pages.index(of: imageViewController)
        else { return }
        index = pageIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            NotificationCenter.default.post(name: .didSwipe, object: nil, userInfo: ["user": StateManager.shared.users[index], "index": index])
        }
    }
}
