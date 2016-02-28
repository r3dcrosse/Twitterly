//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by David Wayman on 2/28/16.
//  Copyright © 2016 David Wayman. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tweetText: UITextView!
    
    var reply: Bool = false
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Set placeholder text for the text view
        tweetText.text = ""
        
        tweetText.becomeFirstResponder()
        
        if reply {
            tweetText.text = "@\(tweet!.user!.screenname!) "
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    @IBAction func onSendTweet(sender: AnyObject) {
        
        // Send the tweet
        var formattedString: String = ""
        
        if tweetText.text != "" || tweetText.text != " " {
            formattedString = tweetText.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            TwitterClient.sharedInstance.sendTweet(formattedString, params: nil, completion:  { (error) -> () in
                self.dismissViewControllerAnimated(true, completion: {})
            })
            
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
