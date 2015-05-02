//
//  HistoryTableViewController.swift
//  Smashtag
//
//  Created by Oleksandr Iaroshenko on 30.04.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    private struct Defaults {
        static let numberOfSections = 1
    }

    private struct Identifiers {
        static let queryCell = "query"
    }

    private var queryHistory = [String]()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let defaults = NSUserDefaults.standardUserDefaults()
        queryHistory = defaults.objectForKey(Keys.queryHistory) as? [String] ?? []
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Defaults.numberOfSections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryHistory.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.queryCell, forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = queryHistory[indexPath.row]

        return cell
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tabVC = segue.destinationViewController as? UITabBarController {
            tabVC.selectedIndex = CommonDefaults.searchTabIndex
            if let navVC = tabVC.viewControllers?[CommonDefaults.searchTabIndex] as? UINavigationController, destination = navVC.visibleViewController as? TweetsTableViewController, indexPath = tableView.indexPathForSelectedRow() {
                destination.searchText = queryHistory[indexPath.row]
            }
        }
    }
}