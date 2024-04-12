
import UIKit
import Alamofire

final class OAuth2ServiceAlamofire {
    
    static let shared = OAuth2ServiceAlamofire(); private init() {}
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<Data, Error>) -> ()) {
        
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
                let decoder = JSONDecoder()
                let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                completion(.success(data))
            } catch {
                completion(.failure(NetworkError.invalidDecoding))
            }
        }
    }
}
