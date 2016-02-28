//
//  TweetCell.swift
//  Twitter
//
//  Created by David Wayman on 2/11/16.
//  Copyright © 2016 David Wayman. All rights reserved.
//

import UIKit
import AFNetworking

protocol TweetCellButtonDelegate: class {
    func retweetClicked(tweetCell: TweetCell)
    func favoriteClicked(tweetCell: TweetCell)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UITextView!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var tweetImage: UIImageView!
    
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var retweetedIcon: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    weak var buttonDelegate: TweetCellButtonDelegate?
    
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
            tweet.isRetweeted! ? // Check if tweet has been retweeted, set button image depending on isRetweeted
                (self.retweetButton.setImage(UIImage(named: "retweet-action-on-pressed.png"), forState: UIControlState.Selected)) :
                (self.retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Selected))
            
            likeCountLabel.text! == "0" ? (likeCountLabel.hidden = true) : (likeCountLabel.hidden = false)
            tweet.isFavorited! ? // Check if tweet has been favorited, set button image depending on isFavorited
                (self.likeButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Selected)) :
                (self.likeButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Selected))
            
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
        buttonDelegate?.retweetClicked(self)
    }
    
    
    @IBAction func onLike(sender: AnyObject) {
        buttonDelegate?.favoriteClicked(self)
    }
    
}


