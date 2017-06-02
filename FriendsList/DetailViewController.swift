//
//  DetailViewController.swift
//  FriendsList
//
//  Created by Madhuri on 1/6/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        if let user = self.user {
            
            var fullName = ""
            if let firstName = user.firstName {
                fullName = firstName
                if let lastName = user.lastName {
                    fullName = "\(firstName) \(lastName)"
                }
            } else {
                if let lastName = user.lastName {
                    fullName = lastName
                }
            }
            
            self.title = fullName
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 1
        if let user = self.user {
            if let photoUrls = user.photoUrls, photoUrls.count > 0 {
                numberOfSections += 1
            }
            if let statuses = user.statuses, statuses.count > 0 {
                numberOfSections += 1
            }
        }
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let user = self.user {
            if (section == 0) {
                return 4
            } else if (section == 1) {
                if let photoUrls = user.photoUrls {
                    return photoUrls.count
                }
                
            } else if (section == 2) {
                if let statuses = user.statuses {
                    return statuses.count
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let user = self.user {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePicTableViewCell") as? ProfilePicTableViewCell {
                        cell.bindData(user: user)
                        cell.selectionStyle = .none
                        return cell
                    }
                    
                } else if (indexPath.row == 1) {
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    cell.textLabel?.text = user.bio ?? "Something about me !!"
                    cell.textLabel?.numberOfLines = 0
                    return cell
                    
                } else if (indexPath.row == 2) {
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    cell.textLabel?.numberOfLines = 0
                    cell.textLabel?.text = "\(user.street ?? ""), \(user.city ?? ""), \(user.state ?? "") - \(user.zipCode ?? "")"
                    return cell
                    
                } else if (indexPath.row == 3) {
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    cell.textLabel?.numberOfLines = 0
                    cell.textLabel?.text = user.phoneNumber ?? "000-000-0000"
                    return cell
                }
                
            } else if (indexPath.section == 1) {
                if let photoUrls = user.photoUrls, indexPath.row < photoUrls.count  {
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    
                    let attributedText = NSMutableAttributedString(string: photoUrls[indexPath.row]!)
                    attributedText.addAttributes([NSLinkAttributeName: photoUrls[indexPath.row]!], range: NSMakeRange(0, attributedText.length))
                    attributedText.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, attributedText.length))
                    attributedText.addAttributes([NSForegroundColorAttributeName: UIColor.blue], range: NSMakeRange(0, attributedText.length))
                    
                    cell.textLabel?.attributedText = attributedText
                    cell.textLabel?.numberOfLines = 0
                    return cell
                }
                
            } else if (indexPath.section == 2) {
                if let statuses = user.statuses, indexPath.row < statuses.count  {
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    cell.textLabel?.numberOfLines = 0
                    cell.textLabel?.text = statuses[indexPath.row]
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 1) {
            return "Photos"
        } else if (section == 2) {
            return "Statuses"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            if let photoUrls = self.user?.photoUrls, indexPath.row < photoUrls.count, let url = URL(string: photoUrls[indexPath.row]!) {
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }

}
