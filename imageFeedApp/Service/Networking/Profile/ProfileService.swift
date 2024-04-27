

import UIKit

final class ProfileService {
    
    // MARK: - Properties
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    var oAuth2TokenStorage = OAuth2TokenStorage()
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Function
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let defaultBaseURL = URL(string: Constants.defaultBaseURL) else {
            preconditionFailure("Ошибка подготовки url профиля")
        }
        guard let url = URL(string: ProfileConstants.urlProfilePath,
                            relativeTo: defaultBaseURL
        ) else {
            assertionFailure("Ошибка создания url профиля")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
        return request
    }
    
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != token {
                task?.cancel()
            } else {
                completion(.failure(ProfileServiceError.invalidRequest))
                return
            }
        }
        lastCode = token
        
        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                        completion(.success(profileResult))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    
    
}
