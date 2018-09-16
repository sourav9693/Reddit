//
//  ApiManager.swift
//  RedditTest
//
//  Created by Sourav Mishra on 16/09/18.
//  Copyright © 2018 RedditTest. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct ApiManagerKeys {
  static let after = "after"
  static let data = "data"
  static let children = "children"
}

typealias ListSuccessCompletion<T>  = (([T]) -> ())
typealias ListFailureCompletion = ((Error) -> ())

class ApiManager: NSObject {
  typealias RedditListSuccessCompletion  = ListSuccessCompletion<Reddit>
  typealias CommentListSuccessCompletion  = ListSuccessCompletion<Comment>
  
  var redditsAfter : String?
  func loadReddits(onSuccess: @escaping RedditListSuccessCompletion, onFailure : @escaping ListFailureCompletion) {
    var url = RedditConstants.Listing_Url.rawValue
    if let after = redditsAfter {
      url.append("?after=\(after)")
    }
    getRedditListRequest(url: url , onSuccess: onSuccess, onFailure: onFailure)
  }
  
  func loadRedditComments(_ reddit: Reddit, onSuccess: @escaping CommentListSuccessCompletion, onFailure : @escaping ListFailureCompletion) {
    let url = reddit.commentsUrl
    getCommentsListRequest(url: url, onSuccess: onSuccess, onFailure: onFailure)
  }
}

private extension ApiManager {
  func getRedditListRequest(url : String, onSuccess: @escaping RedditListSuccessCompletion, onFailure : @escaping ListFailureCompletion) {
    Alamofire.request((RedditConstants.Main_Url.rawValue + url))
      .validate()
      .responseJSON { [weak self] response in
        switch response.result {
        case .success:
          let json = JSON(response.result.value ?? [:])
          let jsonData = json[ApiManagerKeys.data]
          self?.redditsAfter = jsonData[ApiManagerKeys.after].stringValue
          var redditList = [Reddit]()
          for data in jsonData[ApiManagerKeys.children].arrayValue
          {
            let childData = data[ApiManagerKeys.data]
            let child = Reddit(json: childData)
            redditList.append(child)
          }
          onSuccess(redditList)
        case .failure(let error):
          onFailure(error)
        }
    }
  }
  
  func getCommentsListRequest(url : String, onSuccess: @escaping CommentListSuccessCompletion, onFailure : @escaping ListFailureCompletion) {
    var urlPart: String = url
    if url.last == "/" {
      urlPart = String(url.dropLast())
    }
    Alamofire.request((RedditConstants.Main_Url.rawValue + urlPart + ".json"))
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success:
          let jsonArray = JSON(response.result.value ?? [[:]])
          var commentsList = [Comment]()
          for json in jsonArray.arrayValue {
            let jsonData = json[ApiManagerKeys.data]
            for data in jsonData[ApiManagerKeys.children].arrayValue
            {
              let childData = data[ApiManagerKeys.data]
              let child = Comment(json: childData)
              commentsList.append(child)
            }
          }
          onSuccess(commentsList)
        case .failure(let error):
          onFailure(error)
        }
    }
  }

}


