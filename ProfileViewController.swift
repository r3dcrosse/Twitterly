//
//  ProfileViewController.swift
//  Twitter
//
//  Created by David Wayman on 2/27/16.
//  Copyright © 2016 David Wayman. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = tweet.user!.name!
        screenNameLabel.text = "@\(tweet.user!.screenname!)"
        numTweetsLabel.text = String(tweet.user!.numTweets!)
        numFollowersLabel.text = String(tweet.user!.numFollowers!)
        numFollowingLabel.text = String(tweet.user!.numFollowing!)
        
        thumbImageView.setImageWithURL(tweet.user!.profileImageUrl!)
        backgroundImageView.setImageWithURL(tweet.user!.profileBackgroundImageUrl!)
        
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "newTweetSegue" {
            let composeTweetView = segue.destinationViewController as! NewTweetViewController
            composeTweetView.user = User.currentUser
            
        }
    }
    

}
