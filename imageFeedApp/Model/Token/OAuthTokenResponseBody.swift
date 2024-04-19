

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String?
    let tokenType: String
    let scope: String
    let createdAt: Int
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case createdAt = "created_at"
    }
}
//struct OAuthTokenResponseBody: Codable {
//    enum CodingKeys: String, CodingKey {
//        case accessToken = "access_token"
//        case tokenType = "token_type"
//        case scope = "scope"
//        case createdAt = "created_at"
//    }
//    
//    let accessToken: String?
//    let tokenType: String
//    let scope: String
//    let createdAt: Int
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
//        self.tokenType = try container.decode(String.self, forKey: .tokenType)
//        self.scope = try container.decode(String.self, forKey: .scope)
//        self.createdAt = try container.decode(Int.self, forKey: .createdAt)
//    }
//}
