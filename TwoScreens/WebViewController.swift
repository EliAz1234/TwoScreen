//
//  WebViewController.swift
//  TwoScreens
//
//  Created by np on 08/11/2020.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var stringUrl: String?
    var titleFlow: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "First Screen", style: UIBarButtonItem.Style.plain, target: self, action: #selector(WebViewController.tappedBackButton))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        stringUrl =  stringUrl?.replacingOccurrences(of: " ", with:"")
        stringUrl =  stringUrl?.replacingOccurrences(of: "\n", with:"")
        webView.load(URLRequest(url: URL(string: stringUrl! as String)!))
    }
    
    @objc func tappedBackButton(sender: UIBarButtonItem) {

    let storyBoard = UIStoryboard(name:"Main", bundle: nil)
    if let vc = storyBoard.instantiateViewController(withIdentifier: "ViewController") as? ViewController,
        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
        if let urlWrap = self.stringUrl{
            vc.stringUrl = urlWrap
        }
        if let titleWrap = self.titleFlow{
            vc.titleFromWebView = titleWrap
        }
        navController.pushViewController(vc, animated: true)
    }
   }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
    }
}
