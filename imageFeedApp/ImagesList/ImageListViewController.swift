
import UIKit
import Kingfisher

final class ImageListViewController: UIViewController {
    
    // MARK: - View
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    
    private var imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photosList: [Photo] = []
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let alert = AlertPresentor.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        super.viewDidLoad()
        imagesServiceObserve()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let imageURL = URL(string: photosList[indexPath.row].largeImageURL)
            viewController.largeImageURL = imageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Extension

extension ImageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photosList[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImageListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let photos = imagesListService.photos
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photosList.count
        let newCount = imagesListService.photos.count
        photosList = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
}

extension ImageListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let stubImage = UIImage(named: "scribbleVariable") else { return }
        let imageUrl = photosList[indexPath.row].thumbImageURL
        guard let url = URL(string: imageUrl) else { return }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: stubImage) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        cell.cellImage.layer.cornerRadius = 16
        cell.cellImage.layer.masksToBounds = true
        
        cell.setIsLiked(isLiked: photosList[indexPath.row].isLiked)
        let photo = photosList[indexPath.row]
        if let photoCreatedAt = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: photoCreatedAt)
        } else {
            cell.dateLabel.text = ""
        }
      
    }
    
    func imagesServiceObserve() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        imagesListService.fetchPhotosNextPage()
    }
}

extension ImageListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photosList[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLiked: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                self.photosList = self.imagesListService.photos // синехронизируем массив картинок с сервисом
                cell.setIsLiked(isLiked: !photo.isLiked) // меняем индикацию
            case .failure(let error):
                print("Не удалось поставить лайк: \(error)")
                alert.showNetworkError(errorMessage: "Не удалось поставить лайк")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
}
