//
//  ImageListCell.swift
//  imageFeedApp
//
//  Created by Yo on 11/3/24.
//


import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Lifecycle
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell"
    let gradientLayer = CAGradientLayer()
    
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureGradient()
    }
    
    // MARK: - Private
    
    private func configureGradient() {
        
        let firstColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.3)
        let secondColor = firstColor
        let clearColor = UIColor.clear
        
        gradientLayer.frame = dateLabel.bounds
        gradientLayer.bounds.size.height = 31
        gradientLayer.bounds.size.width = bounds.width

        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor, clearColor.cgColor]
        gradientLayer.locations = [0.0, 0.2, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)

        
        dateLabel.layer.insertSublayer(gradientLayer, at: 0)
    
    }
}
