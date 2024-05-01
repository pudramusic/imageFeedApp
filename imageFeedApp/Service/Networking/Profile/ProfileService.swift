

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
        guard let url = URL(string: ProfileConstants.urlProfilePath) else {
            assertionFailure("Ошибка создания url профиля")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
        return request
    }
    
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if lastCode == token { return }
        task?.cancel()
        lastCode = token
        
        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error {
                    completion(.failure(error))
                }
                return
            }
            DispatchQueue.main.async {
                do {
                    let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                    let person = Profile(result: profileResult)
                    completion(.success(person))
                    self.profile = person
                    self.task = nil
                } catch {
                    completion(.failure(error))
                    self.lastCode = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
 
    
}

