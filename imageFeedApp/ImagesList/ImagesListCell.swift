//
//  ImageListCell.swift
//  imageFeedApp
//
//  Created by Yo on 11/3/24.
//


import UIKit

final class ImagesListCell: UITableViewCell { // класс для хранения всех свойств нашей ячейки
    
    
    // MARK: - Lifecycle
    

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    
    
    // MARK: - Properties
    
    
    static let reuseIdentifier = "ImagesListCell" // создаем идентификатор для переиспользования ячейки
    
}
