//
//  Comment.swift
//  RedditTest
//
//  Created by Sourav Mishra on 16/09/18.
//  Copyright © 2018 RedditTest. All rights reserved.
//

import UIKit
import SwiftyJSON

struct CommentApiKeys {
  static let authorFullName = "author_fullname"
  static let title = "title"
  static let body = "body"
  static let thumbnail = "thumbnail"
}

class Comment {

  let authourFullName : String
  let title : String
  let body : String
  let thumbnail : String
  
  init(authourFullName : String,title : String,body : String,thumbnail : String) {
    self.authourFullName = authourFullName
    self.title = title
    self.body = body
    self.thumbnail = thumbnail
  }
  
  convenience init(json : JSON) {
    self.init(authourFullName: json[CommentApiKeys.authorFullName].stringValue, title: json[CommentApiKeys.title].stringValue, body: json[CommentApiKeys.body].stringValue, thumbnail: json[CommentApiKeys.thumbnail].stringValue)
  }
  
}
