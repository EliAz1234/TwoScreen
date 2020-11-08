//
//  TableViewControllerTravels.swift
//  TwoScreens
//
//  Created by np on 07/11/2020.
//

import UIKit

class TableViewControllerTravels: UITableViewController,XMLParserDelegate {
    var myFeed : NSArray = []
    var url: URL!
    struct Const {
        static let TIME_REPEAT = 60.0 * 5
    }
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        self.tableView.dataSource = self
        self.tableView.delegate = self
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        loadData()
        checkDataChangeThread()
    }
    func loadData() {
        url = URL(string: "http://rss.cnn.com/rss/edition_travel.rss")!
        loadRss(url);
    }
    func loadRss(_ data: URL) {

        // XmlParserManager instance/object/variable.
        let myParser : XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager

        // Put feed in array.
        myFeed = myParser.feeds
        
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Table view data source.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFeed.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "title") as? String

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentUrl: String = (myFeed[indexPath.row] as AnyObject).object(forKey: "link") as! String
        let currentTitle: String = (myFeed[indexPath.row] as AnyObject).object(forKey: "title") as! String
        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController,
            let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            vc.stringUrl = currentUrl as String
            vc.titleFlow = currentTitle as String
            navController.pushViewController(vc, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = TableViewControllerTravels.generateRandomColor()
    }
    static func generateRandomColor() -> UIColor {
         let redValue = CGFloat(drand48())
         let greenValue = CGFloat(drand48())
         let blueValue = CGFloat(drand48())

         let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)

         return randomColor
     }
    
    private func checkDataChangeThread() {
        timer = Timer.scheduledTimer(timeInterval: Const.TIME_REPEAT, target: self, selector:#selector(self.checkDataChange) , userInfo: nil, repeats: true)
    }

    @objc func checkDataChange(){
        let myParser : XmlParserManager = XmlParserManager().initWithURL(url) as! XmlParserManager
        
        let tempFeeds = myParser.feeds
        for  element in tempFeeds {
            for  element2 in myFeed {
                
                if (element as AnyObject).object(forKey: "title") as? String ==
                    (element2 as AnyObject).object(forKey: "title") as? String{
                    if (element as AnyObject).object(forKey: "pubDate") as? String !=
                        (element2 as AnyObject).object(forKey: "pubDate") as? String{
                        myFeed = tempFeeds
                        
                    }
                }
            }

        }

//                if (feed[1] as! String == tempFeeds[1] as! String) && (feed[2] as! String  tempFeeds[2] as! String){
//
//                }
    }
        

    
}
