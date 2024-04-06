//
//  AuthViewController.swift
//  imageFeedApp
//
//  Created by Yo on 5/4/24.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: - View
    
    private var authImagView = UIImageView()
    private var loginButton = UIButton()
//    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        configureAuthImageView()
        configureLoginButton()
        
    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == ShowWebViewSegueIdentifier {
//            guard
//                let webViewViewController = segue.destination as? WebViewViewController
//            else {
//                fatalError("Invalid segue destination \(ShowWebViewSegueIdentifier)")
//            }
//            super.prepare(for: segue, sender: sender)
//        }
//    }
    
    // MARK: - Action
    
    @objc
    private func didTapLoginButton() {
//        performSegue(withIdentifier: ShowWebViewSegueIdentifier, sender: Any?.self)
                let webViewVewController = WebViewViewController()
//                webViewVewController.modalPresentationStyle = .fullScreen
                present(webViewVewController, animated: true, completion: nil)
    }
}

// MARK: - Extension

extension AuthViewController {
    
    func configureAuthImageView() {
        authImagView.translatesAutoresizingMaskIntoConstraints = false
        authImagView.image = UIImage(named: "authScreenLogo")
        view.addSubview(authImagView)
        
        NSLayoutConstraint.activate([
            authImagView.heightAnchor.constraint(equalToConstant: 60),
            authImagView.widthAnchor.constraint(equalToConstant: 60),
            authImagView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            authImagView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func  configureLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = .ypWhite
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.ypBlack, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        loginButton.layer.cornerRadius = 16
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(Self.didTapLoginButton), for: .touchUpInside)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -124),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
