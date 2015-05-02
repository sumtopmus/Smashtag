//
//  ImageScrollViewController.swift
//  Smashtag
//
//  Created by Oleksandr Iaroshenko on 30.04.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController, UIScrollViewDelegate {

    private struct Defaults {
        static let color = UIColor.blackColor()
        static let minScale : CGFloat = 0.5
        static let maxScale : CGFloat  = 5
    }

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.contentSize = imageView.frame.size
            scrollView.minimumZoomScale = Defaults.minScale
            scrollView.maximumZoomScale = Defaults.maxScale
        }
    }
    var imageView = UIImageView()

    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    var aspectRatio: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()

                image = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://pp.vk.me/c616323/v616323374/7b66/Fet5WYFOoS8.jpg")!)!)
        
        scrollView.addSubview(imageView)
     }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

//        scrollingView.zoomToRect(imageScrolledView.bounds.size, animated: animated)
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}



////        let aspectRationConstraint = NSLayoutConstraint(item: imageScrolledView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: imageScrolledView, attribute: NSLayoutAttribute.Height, multiplier: aspectRatio!, constant: 0)
////        imageScrolledView.addConstraint(aspectRationConstraint)
//imageScrolledView.image = image
//imageScrolledView.sizeToFit()