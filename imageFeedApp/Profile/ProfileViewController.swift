//
//  ProfileViewController.swift
//  imageFeedApp
//
//  Created by Yo on 18/3/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - View
    
    private let avatarImageView = UIImageView()
    private let logoutButton = UIButton()
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayer()
    }
    
    // MARK: - Action
    
    @objc
    private func didTapLogoutButton() {
        
    }
    
}

// MARK: - Extension

extension ProfileViewController {
    
    // MARK: - Function
    
    func setupLayer() {
        view.backgroundColor = .ypBlack
        configureAvatarImageView()
        configureLogoutButton()
        configureNameLabel()
        configureLoginNameLabel()
        configureDescriptionLabel()
    }
    
    func configureAvatarImageView() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        let avatarImage = UIImage(named: "avatar") ?? UIImage(systemName: "person.crop.circle.fill")
        let avatarImageView = UIImageView(image: avatarImage)
        avatarImageView.tintColor = .ypGray
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
        
    }
    
    func  configureLogoutButton() {
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "exit") ?? UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        logoutButton.tintColor = .ypRed
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 24),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55)
        ])
    }
    
    func configureNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8)
        ])
    }
    
    func configureLoginNameLabel() {
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}


