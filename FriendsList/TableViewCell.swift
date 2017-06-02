//
//  TableViewCell.swift
//  FriendsList
//
//  Created by Madhuri on 31/5/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var onlineStatusView: UIView!
    
    private var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        onlineStatusView.layer.cornerRadius = onlineStatusView.frame.height/2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "default_user")
    }
    
    func bindData(user: User?) {
        
        self.user = user

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
            nameLabel.text = fullName
            statusLabel.text = user.currentStatus
            if user.isAvailable {
                onlineStatusView.backgroundColor = UIColor.green
            } else {
                onlineStatusView.backgroundColor = UIColor.lightGray
            }
            
            weak var weakSelf = self

            profileImageView.image = UIImage(named: "default_user")
            if let imageUrl = user.profilePicUrl, let url = URL(string: imageUrl) {
                NetworkManager.downloadedImageForURL(url: url, completion: { (image, error) in
                    
                    if let image = image, error == nil {
                        DispatchQueue.main.async {
                            weakSelf?.profileImageView.image = image
                        }
                        weakSelf?.user?.profileImage = image
                    }
                })
            }
        }
    }
}
