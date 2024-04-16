
import UIKit

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    
    private enum Keys: String { // создали сущность которую нужно хранить
        case token
        
    }
    
    private let userDefaults = UserDefaults.standard
    
    var token: String {
        get {
            guard let data = userDefaults.data(forKey: Keys.token.rawValue),
                  let token = try? JSONDecoder().decode(String.self, from: data) else {
                return ""
            }
            return token
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Нельзя сохранить Bearer Token")
                return
            }
            
            userDefaults.setValue(data, forKey: Keys.token.rawValue)
        }
    }
}



