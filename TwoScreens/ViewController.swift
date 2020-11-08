//
//  ViewController.swift
//  TwoScreens
//
//  Created by np on 07/11/2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var datewithTime: UILabel!
    
    @IBOutlet weak var emptyTitle: UILabel!
    var timer = Timer()
    var stringUrl: String?
    var titleFromWebView : String?
    
    struct Const {
        static let TIME_REPEAT = 60.0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navController?.popToRootViewController( animated: false )
        
        
        if let title = titleFromWebView{
            emptyTitle.text = title
        }
        setTime()
        exucteCurrentTimeThread()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction))
        emptyTitle.isUserInteractionEnabled = true
        emptyTitle.addGestureRecognizer(tap)
    }

    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController,
            let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            vc.stringUrl = self.stringUrl
            vc.titleFlow = titleFromWebView
            navController.pushViewController(vc, animated: true)
        }
        
    }
    private func exucteCurrentTimeThread() {
        timer = Timer.scheduledTimer(timeInterval: Const.TIME_REPEAT, target: self, selector:#selector(self.setTime) , userInfo: nil, repeats: true)
    }
    
    @objc func setTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        datewithTime.text = formatter.string(from: Date())
    }

}

