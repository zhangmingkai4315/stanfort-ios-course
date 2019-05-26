//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by 明凯张 on 2019/5/26.
//  Copyright © 2019 明凯张. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {


    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    
    var tweet :Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI(){
        tweetTextLabel?.text = tweet?.text
        tweetUserLabel?.text = tweet?.user.description
        if let profileImageURL = tweet?.user.profileImageURL{
            if let imageData = try? Data(contentsOf: profileImageURL){
                tweetProfileImageView?.image = UIImage(data: imageData)
                
            }else{
                tweetProfileImageView?.image = nil
            }
        }
        if let created = tweet?.created{
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60{
                formatter.dateStyle = .short
            }else{
                formatter.dateStyle = .long
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        }else{
            tweetCreatedLabel?.text = nil
        }
    }

}
