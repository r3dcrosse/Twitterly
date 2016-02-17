//
//  TweetCell.swift
//  Twitter
//
//  Created by David Wayman on 2/11/16.
//  Copyright © 2016 David Wayman. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var retweetedIcon: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var tweetID: String = ""
    
    var tweet: Tweet! {
        didSet {
            tweetLabel.text = tweet.text
            nameLabel.text = tweet.user!.name
            usernameLabel.text = "@\(tweet.user!.screenname!)"
            thumbImageView.setImageWithURL(tweet.user!.profileImageUrl!)
            timeAgoLabel.text = calculateTimeStamp(tweet.createdAt!.timeIntervalSinceNow)
            tweetID = tweet.id
            retweetCountLabel.text = String(tweet.retweetCount!)
            likeCountLabel.text = String(tweet.likeCount!)
            
            retweetCountLabel.text! == "0" ? (retweetCountLabel.hidden = true) : (retweetCountLabel.hidden = false)
            likeCountLabel.text! == "0" ? (likeCountLabel.hidden = true) : (likeCountLabel.hidden = false)
            
            if (tweet.isRetweeted!) {
                // set image
                self.retweetButton.setImage(UIImage(named: "retweet-action-on-pressed.png"), forState: UIControlState.Selected)
            } else {
                // set image to not retweeted
                self.retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Selected)
            }
            
            if (tweet.isFavorited!) {
                // set image
                self.likeButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Selected)
            } else {
                self.likeButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Selected)
            }
            
        }
    }
    
    func calculateTimeStamp(timeTweetPostedAgo: NSTimeInterval) -> String {
        // Turn timeTweetPostedAgo into seconds, minutes, hours, days, or years
        var rawTime = Int(timeTweetPostedAgo)
        var timeAgo: Int = 0
        var timeChar = ""
        
        rawTime = rawTime * (-1)
        
        // Figure out time ago
        if (rawTime <= 60) { // SECONDS
            timeAgo = rawTime
            timeChar = "s"
        } else if ((rawTime/60) <= 60) { // MINUTES
            timeAgo = rawTime/60
            timeChar = "m"
        } else if (rawTime/60/60 <= 24) { // HOURS
            timeAgo = rawTime/60/60
            timeChar = "h"
        } else if (rawTime/60/60/24 <= 365) { // DAYS
            timeAgo = rawTime/60/60/24
            timeChar = "d"
        } else if (rawTime/(60/60/24/365) <= 1) { // ROUGH ESTIMATE OF YEARS
            timeAgo = rawTime/60/60/24/365
            timeChar = "y"
        }
        
        return "\(timeAgo)\(timeChar)"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
            
            if self.retweetCountLabel.text! > "0" {
                self.retweetCountLabel.text = String(self.tweet.retweetCount! + 1)
            } else {
                self.retweetCountLabel.hidden = false
                self.retweetCountLabel.text = String(self.tweet.retweetCount! + 1)
            }
            
            // ADD FUNCTION TO RELOAD TABLE CELL
        })
    }
    
    @IBAction func onLike(sender: AnyObject) {
        TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
            
            if self.likeCountLabel.text! > "0" {
                self.likeCountLabel.text = String(self.tweet.likeCount! + 1)
            } else {
                self.likeCountLabel.hidden = false
                self.likeCountLabel.text = String(self.tweet.likeCount! + 1)
            }
            
            // ADD FUNCTION TO RELOAD TABLE CELL
        })
    }
}
