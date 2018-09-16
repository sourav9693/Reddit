//
//  CommentCell.swift
//  RedditTest
//
//  Created by Sourav Mishra on 16/09/18.
//  Copyright © 2018 RedditTest. All rights reserved.
//

import UIKit
import SDWebImage

class CommentCell: UITableViewCell {

  @IBOutlet var authorNameLabel : UILabel!
  @IBOutlet var titleLabel : UILabel!
  @IBOutlet var bodyLabel : UILabel!
  @IBOutlet var thumbNailImageView : UIImageView!
  @IBOutlet var thumbNailImageHeight : NSLayoutConstraint!

  func set(comment : Comment) {
    authorNameLabel.text = comment.authourFullName
    titleLabel.text = comment.title
    bodyLabel.text = comment.body
    if let url =  URL(string: comment.thumbnail) {
      thumbNailImageView.sd_setImage(with: url, completed: nil)
      thumbNailImageHeight.constant = 148.5
    } else {
      thumbNailImageHeight.constant = 0
    }
  }
}
