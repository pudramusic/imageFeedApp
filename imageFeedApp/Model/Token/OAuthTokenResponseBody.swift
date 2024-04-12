//
//  OAuthTokenResponseBody.swift
//  imageFeedApp
//
//  Created by Yo on 12/4/24.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let access_token: String?
    let token_type: String
    let scope: String
    let created_at: Int
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.access_token = try container.decodeIfPresent(String.self, forKey: .access_token)
        self.token_type = try container.decode(String.self, forKey: .token_type)
        self.scope = try container.decode(String.self, forKey: .scope)
        self.created_at = try container.decode(Int.self, forKey: .created_at)
    }
}
