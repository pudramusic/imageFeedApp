//
//  ViewController.swift
//  imageFeedApp
//
//  Created by Yo on 1/3/24.
//

import UIKit

final class ImageListViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    
    private let photoName: [String] = Array(0..<20).map{ "\($0)"} // создаем массив с картинками с названиями от 0 до 19
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long // дата будет отформатирована в длинном стиле
        formatter.timeStyle = .none // отсутствие времени в форматированной строке
        return formatter
    }()
    
    // MARK: - Override
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0) // создаем отступы содержимого ячейки
        
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // метод чтобы открыть выбранную картинку
        if segue.identifier == showSingleImageSegueIdentifier { // делаем проверку сегвея куда будем делать переход
            guard
                let viewController = segue.destination as? SingleImageViewController, // преобразуем segue
                let indexPath = sender as? IndexPath // преобразуем sender
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = UIImage(named: photoName[indexPath.row]) // порлучаем верную картинку по индексу
            viewController.image = image // передаем верную картинку контроллеру
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Extension

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // отвечает за действия после тапа по ячейке
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { // задаем высоту ячейке
        guard let image = UIImage(named: photoName[indexPath.row]) else { // проверяем наличие изображения
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16) // создаем экземпляр который содержит отступы от краев изображения
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right // вычисляем ширину изображения
        let imageWidth = image.size.width // присваиваем ширину исходного изображения
        let scale = imageViewWidth / imageWidth // вычисляем масштаб по ширине, который позволит пропорционально изменить размер картинки для отображения в ячейке
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom // рассчитываем высоту ячейки, учитывая высоту изображения, масштаб и отступы сверху и снизу
        return cellHeight // возвращаем рассчитанную высоту ячейки
    }
}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // метод чтобы таблица знала сколько будет ячеек в секции
        return photoName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // в этом методе создаем ячейку, наполняем данными и передаем таблице
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else { // чтобы работать с ячейкой как с экз класса ImageListCell проводим приведение типов
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath) // вызываем метод конфигурации ячейки
        return imageListCell
    }
}

extension ImageListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) { // метод конфигурации ячейки
        guard let image = UIImage(named: photoName[indexPath.row]) else {
            return
        }
        cell.cellImage.image = image // устанавливаем изображение в ячейку
        cell.cellImage.layer.cornerRadius = 16
        cell.cellImage.layer.masksToBounds = true
        
        cell.dateLabel.text = dateFormatter.string(from: Date()) // устанавливаем дату в ячейку
        
        let isLiked = indexPath.row % 2 == 0 // проверяем нравится ли картинка.
        let likeImage = isLiked ? UIImage(named: "active") : UIImage(named: "noActive")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

