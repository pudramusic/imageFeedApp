
import UIKit

class AuthViewController: UIViewController {
    
    // MARK: - View
    
    private var authImagView = UIImageView()
    private var loginButton = UIButton()
    
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
    }
    
    func webViewViewControllerDidCancell(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
