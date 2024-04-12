
import UIKit
import Alamofire

final class OAuth2ServiceAlamofire {
    
    static let shared = OAuth2ServiceAlamofire(); private init() {}
    
    func fetchOAuthToken(for code: String, completion: @escaping (Result<String, Error>) -> ()) {
        
        let parameters: [String: Any] = [
            "client_id": Constants.accessKey,
            "client_secret": Constants.secretKey,
            "redirect_uri": Constants.redirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        AF.request("https://unsplash.com/oauth/token",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding()).validate().response { response in
            guard let data = response.data else {
                if let error = response.error {
                    completion(.failure(error))
                }
                return
            }
            
            do {
                let oAuthToken = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                guard let accessToken = oAuthToken.access_token else {
                    fatalError("Can't decode token!")
                }
                completion(.success(accessToken))
            } catch {
                completion(.failure(NetworkError.invalidDecoding))
            }
        }
    }
}
