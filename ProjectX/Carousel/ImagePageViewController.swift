//
//  ImagePageViewController.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/13/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class ImagePageViewController: UIPageViewController {
    // MARK: - Properties
    lazy var pages = getPages()
    
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
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func resized(toWidth width: CGFloat) -> UIImage {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }

}
