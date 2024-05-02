
import UIKit

final class ProfileImageService {
    
    // MARK: - Properties
    
    static var shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage()
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    private var lastUserName: String?
    
    // MARK: - init
    
    private init() {}
    
    // MARK: - Function
    
    private func makeProfileImageRequest(username: String) -> URLRequest {
        guard let baseURL = URL(string: OAuthConstants.baseURL) else {
            preconditionFailure("Unable to construct baseUrl")
        }
        guard let url = URL(
            string: "/users/\(username)",
            relativeTo: baseURL
        ) else {
            assertionFailure("Unable to construct url")
            return URLRequest(url: URL(string: "")!)
        }
        guard let token = storage.token else {
            assertionFailure("Failed to make token")
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if lastUserName == username { return }
        task?.cancel()
        lastUserName = username
        
        let request = makeProfileImageRequest(username: username)
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error {
                    completion(.failure(error))
                }
                return
            }
            DispatchQueue.main.async {
                do {
                    let profileImageURL = try JSONDecoder().decode(UserResult.self, from: data)
                    let avatarURL = profileImageURL.profileImage.small
                    completion(.success(avatarURL))
                    self.avatarURL = avatarURL
                    self.task = nil
                } catch {
                    completion(.failure(error))
                    self.lastUserName = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
}
