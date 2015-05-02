//
//  WebViewController.swift
//  Smashtag
//
//  Created by Oleksandr Iaroshenko on 02.05.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView! {
        didSet {
            webView.delegate = self
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }

    @IBAction func goBack(sender: UIButton) {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @IBAction func goForward(sender: UIButton) {
        if webView.canGoForward {
            webView.goForward()
        }
    }

    var url = NSURL() {
        didSet {
            webView?.loadRequest(NSURLRequest(URL: url))
        }
    }

    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var goForwardButton: UIButton!

    func webViewDidFinishLoad(webView: UIWebView) {
        goBackButton.enabled = webView.canGoBack
        goForwardButton.enabled = webView.canGoForward
    }
}