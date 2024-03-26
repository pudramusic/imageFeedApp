//
//  SingleImageViewController.swift
//  imageFeedApp
//
//  Created by Yo on 21/3/24.
//

import UIKit

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
    
    // MARK: - Properties
    
    
    // MARK: - Override
    
    override func viewDidLoad() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        super.viewDidLoad()
        imageView.image = image
        imageView.frame.size = image!.size
        rescaleAndCenterImageInScrollView(image: image!)
        
    }
    
    // MARK: - Action
    
    @IBAction func didTapBackwardButton(_ sender: Any) {
        dismiss(animated: true, completion: nil) // скрываем экран
    }
    
}

// MARK: - extension

extension SingleImageViewController: UIScrollViewDelegate { 
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func rescaleAndCenterImageInScrollView(image: UIImage) { // метод масштабирования изображения под размер экрана
        let minZoomScale = scrollView.maximumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded() // обновляем размеры view
        
        let visibleRectSize = scrollView.bounds.size // после обновления view получаем размеры видимой области
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width // изменяем размер картинки до границ экрана
        let vScale = visibleRectSize.height / imageSize.height // изменяем размер картинки до границ экрана
        let theoreticalScale = min(hScale, vScale)
        let scale = min(maxZoomScale, max(minZoomScale, theoreticalScale)) // определяем финальный масштаба
        
        self.scrollView.setZoomScale(scale, animated: false) // устанавливаем финальный масштаб
        scrollView.layoutIfNeeded() // обновляем размеры subview
        
        let newContentSize = scrollView.contentSize // после обновления subview получаем новые размеры
        let x = (newContentSize.width - visibleRectSize.width) / 2 // центруем по оси Х
        let y = (newContentSize.height - visibleRectSize.height) / 2 // по оси Y
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        
    }
}
