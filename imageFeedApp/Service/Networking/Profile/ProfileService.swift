

import UIKit

final class ProfileService {
    
    // MARK: - Properties
    
    static let shared = ProfileService()
    var oAuth2TokenStorage = OAuth2TokenStorage()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Function
    
    private func makeProfileRequest() -> URLRequest? {
        guard let defaultBaseURL = URL(string: Constants.defaultBaseURL) else {
            preconditionFailure("Ошибка подготовки url профиля")
        }
        guard let url = URL(string: ProfileConstants.urlProfilePath
                            + "?read_user=\(Constants.accessScope)",
                            relativeTo: defaultBaseURL
        ) else {
            assertionFailure("Ошибка создания url профиля")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(oAuth2TokenStorage.token)", forHTTPHeaderField: "Authorization")
        print(request)
        return request
    }
    
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        guard let request = makeProfileRequest() else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.data(for: request) { [ weak self ] result in
            switch result {
            case .success(let data):
                do {
                    let profileData = try JSONDecoder().decode(ProfileResult.self, from: data)
                    completion(.success(profileData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    
}
