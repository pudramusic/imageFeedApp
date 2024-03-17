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
    
}
