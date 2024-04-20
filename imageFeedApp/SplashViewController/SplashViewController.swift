
import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    
    // MARK: - View
    
    private let splashView = UIImageView()
    
    // MARK: - Properties
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oAuthTokenStorage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service.shared
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let token = oAuthTokenStorage.token
        if token != nil {
            switchToTabBarVievController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Override
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Extension

private extension SplashViewController {
    
    func switchToTabBarVievController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController  = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        fetchOAuthToken(code)
    }
    
    func fetchOAuthToken(_ code: String) {
        ProgressHUD.animate()
        oAuth2Service.fetchOAuthToken(for: code) { [weak self] result in
            guard let self = self else { return }
            ProgressHUD.dismiss()
            switch result {
            case .success(let accessToken):
                self.oAuthTokenStorage.token = accessToken
                self.switchToTabBarVievController()
            case .failure(let error):
                break
            }
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
}
