

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    // MARK: - View
    
    private var webView  = WKWebView()
    private var progressIndicator = UIProgressView()
    
    // MARK: - Properties
    
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupLayer()
        configureProgressIndicator()
        loadAuthView()
        webView.navigationDelegate = self
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress,
                                                        options: [],
                                                        changeHandler: { [weak self] _, _ in
            guard let self = self else { return }
            self.updateProgressIndicator()
        })
        updateProgressIndicator()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Override
    
    // MARK: - Action
    
    @objc
    func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancell(self)
    }
}

// MARK: - Extension

private extension WebViewViewController {
    
    // MARK: - Configuration function
    
    func setupLayer() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureProgressIndicator() {
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.progressViewStyle = .default
        progressIndicator.setProgress(0.1, animated: true)
        progressIndicator.tintColor = UIColor.ypBackground
        
        webView.addSubview(progressIndicator)
        
        NSLayoutConstraint.activate([
            progressIndicator.heightAnchor.constraint(equalToConstant: 4),
            progressIndicator.leadingAnchor.constraint(equalTo: webView.safeAreaLayoutGuide.leadingAnchor),
            progressIndicator.trailingAnchor.constraint(equalTo: webView.safeAreaLayoutGuide.trailingAnchor),
            progressIndicator.topAnchor.constraint(equalTo: webView.safeAreaLayoutGuide.topAnchor)
            
        ])
    }
    
    private func updateProgressIndicator() {
        progressIndicator.progress = Float(webView.estimatedProgress)
        progressIndicator.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            assertionFailure("Ошибка подготовки \(WebViewConstants.unsplashAuthorizeURLString)")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        guard let url = urlComponents.url else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
        
        updateProgressIndicator()
    }
}

extension WebViewViewController: WKNavigationDelegate { // проверка авторизации пользователя
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel) // если код получен то отменяем навигационное действие
        } else {
            decisionHandler(.allow) // если код НЕ получен то разрешаем навигационное действие
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      print(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
      print(error)
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == WebViewConstants.urlComponentsPath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
