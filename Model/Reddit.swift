//
//  Reddit.swift
//  RedditTest
//
//  Created by Sourav Mishra on 16/09/18.
//  Copyright © 2018 RedditTest. All rights reserved.
//

import UIKit
import SwiftyJSON

struct RedditApiKeys {
  static let title = "title"
  static let thumbnail = "thumbnail"
  static let commentsUrl = "permalink"
}

class Reddit {

  let title : String
  let thumbnail : String
  let commentsUrl : String
  
  
  init(title : String, thumbnail : String, commentsUrl : String ) {
    self.title = title
    self.thumbnail = thumbnail
    self.commentsUrl = commentsUrl
  }
  
  convenience init(json : JSON) {
    self.init(title: json[RedditApiKeys.title].stringValue, thumbnail: json[RedditApiKeys.thumbnail].stringValue, commentsUrl : json[RedditApiKeys.commentsUrl].stringValue)
  }
}

extension Reddit : CustomStringConvertible {
  var description: String {
    return "\n\ntitle : \(title)\nthumbnail : \(thumbnail)"
  }
}


