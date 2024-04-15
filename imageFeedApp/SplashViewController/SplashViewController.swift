//
//  SplashViewController.swift
//  imageFeedApp
//
//  Created by Yo on 15/4/24.
//

import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - View
    
    private let splashView = UIImageView()
    
    // MARK: - Properties
    
    private let oAuthTokenStorage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service.shared
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSplash()
        
        if oAuthTokenStorage.token == nil {
            segueToNavigationController()
            
        } else {
            switchToTabBarVievController()
        }
    }
}

// MARK: - Extension

private extension SplashViewController {
    
    func configureSplash() {
        splashView.translatesAutoresizingMaskIntoConstraints = false
        splashView.backgroundColor = .ypBlack
        splashView.image = UIImage(named: "VectorLaunchScreen")
        view.addSubview(splashView)
        
        NSLayoutConstraint.activate([
            splashView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            splashView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    
    func switchToTabBarVievController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController  = tabBarController
    }
    
    func segueToNavigationController() {
        guard let navigationController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "NavigationController") as? UINavigationController,
              let viewController = navigationController.viewControllers[0] as? AuthViewController
        else {
                assertionFailure("Unable to instantiate NavigationController")
                return
            }

        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        oAuth2Service.fetchOAuthToken(for: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let accessToken):
                self.oAuthTokenStorage.token = accessToken
            case .failure(let error):
                break
            }
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarVievController()
    }
}
