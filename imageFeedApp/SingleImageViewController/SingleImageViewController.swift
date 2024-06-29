
import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return } // проверяем был ли раньше загружен view
            imageView.image = image
            if let image = image {
                rescaleAndCenterImageInScrollView(image: image)
            }
        }
    }
    
    // MARK: - Lifecycle
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var backwardButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    
    // MARK: Properties
    
    var largeImageURL: URL!
    private let alert = AlertPresentor.shared
    
    // MARK: - Override
    
    override func viewDidLoad() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        super.viewDidLoad()
        imageView.image = image
        imageView.frame.size = image!.size
        rescaleAndCenterImageInScrollView(image: image!)
        scrollView.zoomScale = scrollView.maximumZoomScale
        showLargeImage()
        
    }
    
    // MARK: - Action
    
    @IBAction func didTapBackwardButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(activityItems: [image],
                                             applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
}

// MARK: - extension

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func rescaleAndCenterImageInScrollView(image: UIImage) { // масштабирование изображения под размер экрана
        let minZoomScale = scrollView.maximumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded() // обновляем размеры view
        
        let visibleRectSize = scrollView.bounds.size // размеры видимой области
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width // размер картинки до границ экрана
        let vScale = visibleRectSize.height / imageSize.height // размер картинки до границ экрана
        let theoreticalScale = min(hScale, vScale)
        let scale = min(maxZoomScale, max(minZoomScale, theoreticalScale)) // финальный масштаб
        
        self.scrollView.setZoomScale(scale, animated: false) // устанавливаем финальный масштаб
        scrollView.layoutIfNeeded() // обновляем размеры subview
        
        let newContentSize = scrollView.contentSize // после обновления subview получаем новые размеры
        let x = (newContentSize.width - visibleRectSize.width) / 2 // центруем по оси Х
        let y = (newContentSize.height - visibleRectSize.height) / 2 // по оси Y
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) { // вычисляем внутренние отступы, чтобы оцентровать картинку после зумирования
        let boundSize = scrollView.bounds.size
        let frameToCenter = imageView.frame
        let contentInsetX = max((boundSize.width - frameToCenter.size.width) * 0.5, 0)
        let contentInsetY = max((boundSize.height - frameToCenter.size.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: contentInsetY, left: contentInsetX, bottom: contentInsetY, right: contentInsetX) // устанавливаем внутренние отступы
        scrollView.contentInsetAdjustmentBehavior = .automatic // устанавливаем отскок содержимого внутри отступов
    }
    
    func showLargeImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: largeImageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.rescaleAndCenterImageInScrollView(image: image.image)
            case .failure:
                self.showError()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать еще раз?",
            preferredStyle: .alert)
        let dismissAction = UIAlertAction(
            title: "Нет",
            style: .default) { _ in
                alert.dismiss(animated: true)
            }
        let retryAction = UIAlertAction(
            title: "Да",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.showLargeImage()
            }
        alert.addAction(dismissAction)
        alert.addAction(retryAction)
        self.present(alert, animated: true)
    }
}
