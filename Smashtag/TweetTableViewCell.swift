//
//  TweetViewCell.swift
//  Smashtag
//
//  Created by Oleksandr Iaroshenko on 28.04.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    private struct Colors {
        static let hashtagColor = UIColor.orangeColor()
        static let urlColor = UIColor.blueColor()
        static let userMentionColor = UIColor.purpleColor()
    }

    @IBOutlet weak var authorAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetText: UILabel!

    var tweet: Tweet! {
        didSet {
            updateUI()
        }
    }

    func updateUI() {
        tweetText?.attributedText = nil
        userName?.text = nil
        authorAvatar?.image = nil

        if let tweet = self.tweet {
            var coloredText = NSMutableAttributedString(string: tweet.text)
            for hashtag in tweet.hashtags {
                coloredText.addAttribute(NSForegroundColorAttributeName, value: Colors.hashtagColor, range: hashtag.nsrange)
            }
            for url in tweet.urls {
                coloredText.addAttribute(NSForegroundColorAttributeName, value: Colors.urlColor, range: url.nsrange)
            }
            for userMention in tweet.userMentions {
                coloredText.addAttribute(NSForegroundColorAttributeName, value: Colors.userMentionColor, range: userMention.nsrange)
            }
            tweetText?.attributedText = coloredText
            if tweetText?.text != nil {
                for _ in tweet.media {
                    tweetText.text! += " 📷"
                }
            }

            userName?.text = "\(tweet.user.screenName)"

            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            let queue = dispatch_get_global_queue(qos, 0)
            dispatch_async(queue) {
                if let authorAvatarURL = tweet.user.profileImageURL, imageData = NSData(contentsOfURL: authorAvatarURL) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.authorAvatar?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}