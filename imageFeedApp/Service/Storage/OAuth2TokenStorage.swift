
import UIKit

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    
    private enum Keys: String { // создали сущность которую нужно хранить
        case token
        
    }
    static let shared = OAuth2TokenStorage()
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            return userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    func logout() {
        userDefaults.removeObject(forKey: Keys.token.rawValue)
    }
}



