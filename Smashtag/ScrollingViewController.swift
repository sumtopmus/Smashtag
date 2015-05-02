//
//  ScrollingViewController.swift
//  Smashtag
//
//  Created by Oleksandr Iaroshenko on 01.05.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class ScrollingViewController: UIViewController, UIScrollViewDelegate {

    private struct Defaults {
        static let color = UIColor.blackColor()
        static let maxScale : CGFloat  = 5.0
    }

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.contentSize = imageSize
        }
    }

    var imageView = UIImageView()

    var image: UIImage? {
        didSet {
            if image != nil {
                imageSize = image!.size
                aspectRatio = imageSize.width / imageSize.height
            }

            imageView.image = image
            imageView.sizeToFit()

            scrollView?.contentSize = imageSize
        }
    }

    private var imageSize = CGSize()
    private var aspectRatio = CGFloat()

    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame

        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }

        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
    }

    func calculateAndUpdateZoomScale() {
        let scaleWidth = scrollView.frame.size.width / imageSize.width
        let scaleHeight = scrollView.frame.size.height / imageSize.height
        let minScale = min(scaleWidth, scaleHeight)

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = max(scaleWidth, scaleHeight)
        scrollView.maximumZoomScale = max(Defaults.maxScale, scrollView.zoomScale)
    }

    @IBAction func toggleNavigationBar(sender: UITapGestureRecognizer) {
        let hidden = navigationController!.navigationBar.hidden
        navigationController!.setNavigationBarHidden(!hidden, animated: true)
    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        navigationController?.setNavigationBarHidden(true, animated: true)

        scrollView.contentSize = imageSize

        calculateAndUpdateZoomScale()
        centerScrollViewContents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.contentMode = UIViewContentMode.Center
        scrollView.contentMode = UIViewContentMode.ScaleToFill
        scrollView.addSubview(imageView)
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}