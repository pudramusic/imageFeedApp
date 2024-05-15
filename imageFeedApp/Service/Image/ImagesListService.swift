

import UIKit

final class ImagesListService {
    
    // MARK: - Properties
    
    static let shared = ImagesListService()
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    private let urlSession = URLSession.shared
    
    // MARK: - Function
    
    func fetchPhotosNextPage() {
        // Здесь получим страницу номер 1, если ещё не загружали ничего,
        // и следующую страницу (на единицу больше), если есть предыдущая загруженная страница
        
        let nextPage = (lastLoadedPage?.number ?? 0) + 1
    }
}
