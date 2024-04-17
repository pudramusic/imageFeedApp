
import UIKit

class AuthViewController: UIViewController {
    
    // MARK: - View
    
    private var authImageView = UIImageView()
    private var loginButton = UIButton()
    
    // MARK: Properties
    
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        configureAuthImageView()
        configureLoginButton()
        configureBackButton()
    }
    
    // MARK: - Action
    
    @objc
    private func didTapLoginButton() {
        segueToWebView()
    }
    
    @objc
    private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension

private extension AuthViewController {
    
    func configureAuthImageView() {
        authImageView.translatesAutoresizingMaskIntoConstraints = false
        authImageView.image = UIImage(named: "authScreenLogo")
        view.addSubview(authImageView)
        
        NSLayoutConstraint.activate([
            authImageView.heightAnchor.constraint(equalToConstant: 60),
            authImageView.widthAnchor.constraint(equalToConstant: 60),
            authImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            authImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
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
        loginButton.addTarget(self,
                              action: #selector(Self.didTapLoginButton),
                              for: .touchUpInside)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -124),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage.backward
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapBackButton))
        navigationItem.backBarButtonItem?.tintColor = UIColor.ypBlack
    }
    
    func segueToWebView() {
        let webViewVewController = WebViewViewController()
        navigationController?.pushViewController(webViewVewController, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //navigationController?.popViewController(animated: true)
        delegate?.authViewController(self, didAuthenticateWithCode: code)
        
//        oAuth2Service.fetchOAuthToken(for: code) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let accessToken):
//                self.oAuth2TokenStorage.token = accessToken
//                print("Debug \(accessToken)")
//             
//            case.failure(let error):
//                print(error)
//                break
//            }
//        }
    }
    
    func webViewViewControllerDidCancell(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
}
