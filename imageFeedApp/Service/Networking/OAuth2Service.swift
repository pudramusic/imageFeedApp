import UIKit


final class OAuth2Service {
    
    // MARK: - Properties
    
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask? // указатель на последнюю задчу
    private var lastCode: String? // переменная переденная в последнем запросе
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Function
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: OAuthConstants.baseURL) else {
            preconditionFailure("Unable to construct baseUrl")
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            assertionFailure("Unable to construct url")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(for code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
            }
        }
        
        lastCode = code
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        
        let requestWithCode = makeOAuthTokenRequest(code: code)
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    do {
                        let oAuthToken = try JSONDecoder().decode(OAuthTokenResponseBody.self, from:data)
                        guard let accessToken = oAuthToken.accessToken else {
                            fatalError("Can`t decode token!")
                        }
                        completion(.success(accessToken))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
                self?.task = nil
                self?.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    
}
