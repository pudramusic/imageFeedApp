//
//  ProfileViewController.swift
//  imageFeedApp
//
//  Created by Yo on 18/3/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var logoutButton: UIButton!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    // MARK: - Action
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
    }
    
}
