//
//  CommentsListVC.swift
//  CommentTest
//
//  Created by Sourav Mishra on 16/09/18.
//  Copyright © 2018 CommentTest. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class CommentsListVC: UIViewController {
  @IBOutlet var listingView : UITableView!
  var reddit : Reddit!
  var apiManager : ApiManager!
  var comments = [Comment]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Comment Listing"
    listingView.tableFooterView = UIView()
    listingView.allowsSelection = false
    listingView.register(UINib(nibName: "CommentCell", bundle: .main), forCellReuseIdentifier: "CommentCell")
    listingView.dataSource = self
    apiManager = ApiManager()
    SVProgressHUD.show()
    loadData {
      SVProgressHUD.dismiss()
    }
  }
}

extension CommentsListVC : UITableViewDataSource
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
    let comment = comments[indexPath.row]
    cell.set(comment: comment)
    return cell
  }
}

private extension CommentsListVC
{
  func loadData(_ completion: (() -> ())? = nil) {
    apiManager.loadRedditComments(reddit, onSuccess: {[weak self] (comments) in
      completion?()
      self?.comments += comments
      self?.listingView.reloadData()
    }) { [weak self] (error) in
      completion?()
      let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
      self?.present(alert, animated: true, completion: nil)
    }
    
  }
}
