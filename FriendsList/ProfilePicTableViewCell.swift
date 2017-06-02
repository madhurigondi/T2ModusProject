//
//  ProfilePicTableViewCell.swift
//  FriendsList
//
//  Created by Madhuri on 1/6/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class ProfilePicTableViewCell: UITableViewCell {

    @IBOutlet private weak var profilePicImageView: UIImageView!
    @IBOutlet private weak var statusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height/2
    }
    
    
    func bindData(user: User?) {
        
        if let user = user {
            
            if user.isAvailable {
                statusImageView.image = UIImage(named: "online")
            } else {
                statusImageView.image = UIImage(named: "offline")
            }
            
            if let profileImage = user.profileImage {
                profilePicImageView.image = profileImage
                return
            }
            
            weak var weakSelf = self
            
            profilePicImageView.image = UIImage(named: "default_user")
            if let imageUrl = user.profilePicUrl, let url = URL(string: imageUrl) {
                NetworkManager.downloadedImageForURL(url: url, completion: { (image, error) in
                    
                    if let image = image, error == nil {
                        DispatchQueue.main.async {
                            weakSelf?.profilePicImageView.image = image
                        }
                        user.profileImage = image
                    }
                })
            }
        }
    }

}
