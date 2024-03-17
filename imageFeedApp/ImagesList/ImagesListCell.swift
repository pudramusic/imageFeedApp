//
//  ImageListCell.swift
//  imageFeedApp
//
//  Created by Yo on 11/3/24.
//


import UIKit

final class ImagesListCell: UITableViewCell { // класс для хранения всех свойств нашей ячейки
    
    // MARK: - Lifecycle
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell" // создаем идентификатор для переиспользования ячейки
    let gradientLayer = CAGradientLayer()
    
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureGradient()
    }
    
    // MARK: - Private
    
    private func configureGradient() {
        
        let firstColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.2)
        let secondColor = firstColor
        let clearColor = UIColor.clear
        
        gradientLayer.frame = dateLabel.bounds // устанавливаем размер подложки как и у UILabel
        gradientLayer.bounds.size.height = 30
        gradientLayer.bounds.size.width = bounds.width

        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor, clearColor.cgColor] // задаем цвпета градиента
        gradientLayer.locations = [0.0, 0.2, 1.0] // выставляем стоп градиента на 20%
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 2.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: -2.0)

        
        dateLabel.layer.insertSublayer(gradientLayer, at: 0)
    
    }
}
