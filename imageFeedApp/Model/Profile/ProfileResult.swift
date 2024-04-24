
import UIKit

struct ProfileResult: Codable {
    enum CodingKeys: String, CodingKey {
        case loginName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
    let loginName: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.loginName = try container.decode(String.self, forKey: .loginName)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
    }
}
