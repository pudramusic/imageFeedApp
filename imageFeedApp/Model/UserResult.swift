
import UIKit

struct UserResult: Codable {
    let profileImage: ImageSize
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ImageSize: Codable {
    let small: String
}
