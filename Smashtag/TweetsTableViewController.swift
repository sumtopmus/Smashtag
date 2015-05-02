//
//  TwitsTableViewController.swift
//  
//
//  Created by Oleksandr Iaroshenko on 28.04.15.
//
//

import UIKit

class TweetsTableViewController: UITableViewController, UITextFieldDelegate {

    private struct Storyboard {
        static let tweetCell = "TweetCell"
    }

    private struct Defaults {
        static let tweetsFetchingCount = 100
        static let searchText = "#kharkiv"
        static let rowHeight: CGFloat = 80
    }

    var tweets = [[Tweet]]()

    var searchText: String? = Defaults.searchText {
        didSet {
            lastSuccessfullRequest = nil
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            updateTweets()
            updateHistory()
        }
    }

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

//        tabBarController?.

        tableView.estimatedRowHeight = Defaults.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        updateTweets()
    }

    // MARK: - Update tweets list

    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }

    private func updateHistory() {
        if let newQuery = searchText {
            let defaults = NSUserDefaults.standardUserDefaults()
            var queryHistory = defaults.objectForKey(Keys.queryHistory) as? [String] ?? []
            defaults.removeObjectForKey(Keys.queryHistory)
            if queryHistory.filter({ $0 == newQuery }).count > 0 {
                queryHistory = queryHistory.filter { $0 != newQuery }
            }
            if queryHistory.count >= Keys.maxHistorySize {
                queryHistory.removeRange(Keys.maxHistorySize-1...queryHistory.count-1)
            }
            queryHistory.insert(newQuery, atIndex: 0)
            defaults.setObject(queryHistory, forKey: Keys.queryHistory)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = searchTextField.text
        }
        return true
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if let searchTextUnwrapped = searchText {
            if let request = nextRequestToAttempt {
                request.fetchTweets { (newTweets) -> Void in
                    if newTweets.count > 0 {
                        self.lastSuccessfullRequest = request
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                            sender?.endRefreshing()
                        }
                    }
                }
            }
        }
        refreshControl?.endRefreshing()
    }

    var lastSuccessfullRequest: TwitterRequest?

    var nextRequestToAttempt: TwitterRequest? {
        let result: TwitterRequest?
        if lastSuccessfullRequest == nil {
            if let searchTextUnwrapped = searchText {
                result = TwitterRequest(search: searchTextUnwrapped, count: Defaults.tweetsFetchingCount)
            } else {
                result = nil
            }
        } else {
            result = lastSuccessfullRequest?.requestForNewer
        }
        return result
    }

    func updateTweets() {
        if let refreshControlUnwrapped = refreshControl {
            refreshControlUnwrapped.beginRefreshing()
        }
        refresh(refreshControl)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.tweetCell, forIndexPath: indexPath) as! TweetTableViewCell

        cell.tweet = tweets[indexPath.section][indexPath.row]

        return cell
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navVC = destination as? UINavigationController {
            destination = navVC.visibleViewController
        }
        if let mentionsViewController = destination as? MentionsTableViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                mentionsViewController.tweet = tweets[indexPath.section][indexPath.row]
            }
        }
    }

    @IBAction func goBackAndSearch(segue: UIStoryboardSegue) {
    }
}
















