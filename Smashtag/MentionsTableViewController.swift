//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Oleksandr Iaroshenko on 29.04.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {

    private enum ItemToMention {
        case Image(MediaItem)
        case Hashtag(String)
        case URL(String)
        case UserMention(String)
    }

    private class Mentions {
        static let userSymbol = "@"
        static let title = ["Images", "Hashtags", "URLs", "User Mentions"]

        var data = [[ItemToMention]](count: 4, repeatedValue: [ItemToMention]())

        init (fromTweet tweet: Tweet) {
            data[0] = tweet.media.map { .Image($0) }
            data[1] = tweet.hashtags.map { .Hashtag($0.keyword) }
            data[2] = tweet.urls.map { .URL($0.keyword) }
            data[3] = [.UserMention(Mentions.userSymbol + tweet.user.screenName)] + tweet.userMentions.map { .UserMention($0.keyword) }
        }

        func getMediaItem(indexPath: NSIndexPath) -> MediaItem? {
            switch data[indexPath.section][indexPath.row] {
            case .Image(let mediaItem):
                return mediaItem
            default:
                return nil
            }
        }

        func getString(indexPath: NSIndexPath) -> String? {
            switch data[indexPath.section][indexPath.row] {
            case .Hashtag(let string):
                return string
            case .URL(let string):
                return string
            case .UserMention(let string):
                return string
            default:
                return nil
            }
        }
    }

    private struct TwitterOperators {
        static let or = " OR "
        static let postedBy = "from:"
    }

    private var mentions: Mentions?

    private func updateModel() {
        if tweet != nil {
            mentions = Mentions(fromTweet: tweet!)
        }
    }

    var tweet: Tweet? {
        didSet {
            updateModel()
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions?.data[section].count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch indexPath.section {
        case 0:
            let dequeuedCell = tableView.dequeueReusableCellWithIdentifier("cellWithImage", forIndexPath: indexPath) as! MediaTableViewCell
            dequeuedCell.mediaItem = mentions?.getMediaItem(indexPath)
            cell = dequeuedCell
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("cellWithURL", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = mentions?.getString(indexPath)
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("cellWithText", forIndexPath: indexPath) as! UITableViewCell
                cell.textLabel?.text = mentions?.getString(indexPath)
        }
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions?.data[section].count > 0 ? Mentions.title[section] : nil
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height: CGFloat
        if indexPath.section == 0 && mentions != nil {
            let width = self.tableView.frame.size.width
            height = width / CGFloat(mentions!.getMediaItem(indexPath)!.aspectRatio)
        } else {
            height = UITableViewAutomaticDimension
        }
        return height
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let indexPath = tableView.indexPathForSelectedRow() {
            switch indexPath.section {
            case 0:
                if let imageScrollViewController = destination as? ScrollingViewController, selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? MediaTableViewCell {
                    imageScrollViewController.image = selectedCell.imageViewInCell?.image
                }
            case 1:
                if let tweetsTableViewController = destination as? TweetsTableViewController {
                    tweetsTableViewController.searchText = mentions?.getString(indexPath)
                }
            case 2:
                if let url = NSURL(string: mentions!.getString(indexPath)!) {
//                    UIApplication.sharedApplication().openURL(url)
                    if let webViewController = destination as? WebViewController {
                        webViewController.url = url
                    }
                }
            case 3:
                if let tweetsTableViewController = destination as? TweetsTableViewController {
                    let user: String = mentions!.getString(indexPath)!
                    let userNoSymbol: String = user.substringFromIndex(user.startIndex.successor())
                    let searchQuery = user + TwitterOperators.or + TwitterOperators.postedBy + userNoSymbol
                    tweetsTableViewController.searchText = searchQuery
                }
            default:
                break
            }
        }
    }
}
