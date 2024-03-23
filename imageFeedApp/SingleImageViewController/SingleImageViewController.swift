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
        }
    }
    
    // MARK: - Lifecycle
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var backwardButton: UIButton!
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    // MARK: - Action
    
    @IBAction func didTapBackwardButton(_ sender: Any) {
        dismiss(animated: true, completion: nil) // скрываем экран
    }
    
}
