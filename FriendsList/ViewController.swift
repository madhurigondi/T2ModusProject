//
//  ViewController.swift
//  FriendsList
//
//  Created by Madhuri on 31/5/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    private var usersList: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.isHidden = true
        self.title = "Friends List"
        fetchAllFriends()
        
    }
    
    func fetchAllFriends() {
        weak var weakSelf = self
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        NetworkManager.fetchAllFriends { (response, error) in
            weakSelf?.activityIndicator.stopAnimating()
            guard let _ = error else {
                if let usersList = response as? [User] {
                    self.activityIndicator.stopAnimating()
                    weakSelf?.usersList = usersList
                    self.tableView.isHidden = false
                    weakSelf?.tableView.reloadData()
                }
                return
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let usersList = self.usersList {
            return usersList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let usersList = self.usersList, indexPath.row < usersList.count, let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell {
            let user = usersList[indexPath.row]
            cell.bindData(user: user)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let usersList = self.usersList, indexPath.row < usersList.count {
            let user = usersList[indexPath.row]
            weak var weakSelf = self
            NetworkManager.fetchUserDetails(user: user) { (response, error) in
                
                DispatchQueue.main.async {
                  guard let _ = error else {
                    if let user = response as? User, let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                        controller.user = user
                            weakSelf?.navigationController?.pushViewController(controller, animated: true)
                    }
                      return
                    }
                }
            }
        }
    }
}

