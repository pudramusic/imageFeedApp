

import UIKit

final class ImagesListService {
    
    // MARK: - Properties
    
    static let shared = ImagesListService()
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage()
    let dateFormatter = ISO8601DateFormatter()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Function
    
    func makeImageRequest(page: Int) -> URLRequest? {
        guard let baseUrl = URL(string: Constants.defaultBaseURL) else {
            preconditionFailure("Ошибка создания baseUrl")
        }
        
        guard let url = URL(string: "/photos"
                            + "?page=\(page)"
                            + "&&per_page=10",
                            relativeTo: baseUrl) else {
            assertionFailure("Ошибка создания url")
            return nil
        }
        
        guard let token = storage.token else {
            assertionFailure("Failed to make token")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
        return request
        
        
    }
    
    func fetchPhotosNextPage() {
        
        assert(Thread.isMainThread)
        if task != nil { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
        lastLoadedPage = nextPage
        
        guard let requestImages = makeImageRequest(page: nextPage) else {
            assertionFailure("нет доступа к базе изображений")
            return
        }
        
        let task = urlSession.objectTask(for: requestImages) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResult):
                    self.preparePhoto(photoResult: photoResult)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                    object: self,
                                                    userInfo: ["photos": self.photos])
                case .failure(let error):
                    print(error)
                }
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func preparePhoto(photoResult: [PhotoResult]) {
        let newPhotos = photoResult.map { item in
            Photo(id: item.id,
                  size: CGSize(width: item.width, height: item.height),
                  createdAt: dateFormatter.date(from: item.createdAt!),
                  welcomeDescription: item.description,
                  thumbImageURL: item.urls.thumb,
                  largeImageURL: item.urls.full,
                  isLiked: item.isLiked)
        }
        photos.append(contentsOf: newPhotos)
    }
 
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let baseUrl = URL(string: Constants.defaultBaseURL) else {
            preconditionFailure("Ошибка создания baseUrl")
        }
        
        guard let url = URL(string: "/photos"
                            + "?\(photoId)"
                            + "&&like",
                            relativeTo: baseUrl) else {
            assertionFailure("Ошибка создания url")
            return 
        }
        
        assert(Thread.isMainThread)
        guard let token = storage.token else {
            return assertionFailure("Ошибка получения токена")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLiked ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
//        return request
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let likeResult):
                // Поиск индекса элемента
                if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                    let photo = self.photos[index]
                // Копия элемента с инвертированным значением isLiked
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked)
                // Заменяем элемент в массиве
                    self.photos[index] = newPhoto
                }
                completion (.success(()))
            case .failure(let error):
                completion (.failure(error))
            }
        }
        task.resume()
    }
}
