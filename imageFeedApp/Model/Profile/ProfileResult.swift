
import UIKit

struct ProfileResult: Codable {
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
    let userName: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    var name: String {
        var fullName = ""
        if let firstName = firstName {
            fullName += firstName
        }
        if let lastName = lastName {
            fullName += " " + lastName
        }
        return fullName
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
    }
}
