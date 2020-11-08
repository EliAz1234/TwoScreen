//
//  TableViewControllerSportAndEntertainment.swift
//  TwoScreens
//
//  Created by np on 07/11/2020.
//

import UIKit

class TableViewControllerSportAndEntertainment:  UITableViewController,XMLParserDelegate {
    var myFeed = NSMutableArray()
    var url1,url2: URL!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        loadData()
    }
    func loadData() {
        url1 = URL(string: "http://rss.cnn.com/rss/edition_sport.rss")!
        url2 = URL(string: "http://rss.cnn.com/rss/edition_entertainment.rss")!
        loadRss(url1,url2);

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPage2" {
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            let currentUrl: String = (myFeed[indexPath.row] as AnyObject).object(forKey: "link") as! String

            // Instance of our feedpageviewcontrolelr.
            let webV: WebViewController = segue.destination as! WebViewController
            webV.stringUrl = currentUrl as String
        }
    }
    func loadRss(_ data1: URL,_ data2: URL) {

        // XmlParserManager instance/object/variable.
        let myParserSport : XmlParserManager = XmlParserManager().initWithURL(data1) as! XmlParserManager

        // Put feed in array.
        myFeed =  myParserSport.feeds
        
        let myParserEntertainment : XmlParserManager = XmlParserManager().initWithURL(data2) as! XmlParserManager

        // Put feed in array.
        for feed in myParserEntertainment.feeds {
            myFeed.add(feed)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
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
}
