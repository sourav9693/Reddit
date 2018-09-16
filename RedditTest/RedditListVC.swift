//
//  ViewController.swift
//  RedditTest
//
//  Created by Sourav Mishra on 16/09/18.
//  Copyright © 2018 RedditTest. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class RedditListVC: UIViewController {
  @IBOutlet var listingView : UITableView!
  var apiManager : ApiManager!
  var reddits = [Reddit]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Reddit Listing"
    listingView.tableFooterView = UIView()
    listingView.delegate = self
    listingView.dataSource = self
    apiManager = ApiManager()
    SVProgressHUD.show()
    loadData {
      SVProgressHUD.dismiss()
    }
  }
}

extension RedditListVC : UITableViewDelegate
{
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row + 1 == reddits.count {
      loadData()
     }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let commentView : CommentsListVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentsListVC") as! CommentsListVC
    commentView.reddit = reddits[indexPath.row]
    self.navigationController?.pushViewController(commentView, animated: true)
  }
}

extension RedditListVC : UITableViewDataSource
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reddits.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
    let reddit = reddits[indexPath.row]
    cell.textLabel?.text = reddit.title
    cell.textLabel?.numberOfLines = 0
    cell.imageView?.sd_setImage(with: URL(string: reddit.thumbnail), completed: nil)
    return cell
  }
}

private extension RedditListVC
{
  func loadData(_ completion: (() -> ())? = nil) {
    apiManager.loadReddits(onSuccess: {[weak self] (reddits) in
      self?.reddits += reddits
      self?.listingView.reloadData()
      completion?()
    }) { [weak self] (error) in
      completion?()
      let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
      self?.present(alert, animated: true, completion: nil)
    }
    
  }
}
