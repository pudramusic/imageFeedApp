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
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long // дата будет отформатирована в длинном стиле
        formatter.timeStyle = .none // отсутствие времени в форматированной строке
        return formatter
    }()
    
    // MARK: - Override
    
    override func viewDidLoad() {
        
        tableView.dataSource = self // устанавливаем связь с DataSourse, где self это контроллер, который должен выступать как датаСорс
        tableView.delegate = self // устанавливаем связь с Delegate, где self это контроллер, который должен выступать как делегат
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0) // создаем отступы содержимого ячейки

        super.viewDidLoad()
        
    }
}

    // MARK: - Extension

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // отвечает за действия, которые будут выполнены после тапа
        tableView.deselectRow(at: indexPath, animated: true) // убираем подсветку после тапа
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { // задаем высоту ячейке, т.к ячейки имеют «динамическую» высоту — то есть зависят от размеров фото, которые они отображают. Метод возвращает высоту строки
        guard let image = UIImage(named: photoName[indexPath.row]) else { // проверяем наличие изображения
            return 0 // если изображения нет, то возвращаем высоту строки равную 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16) // создаем экземпляр который содержит отступы от краев изображения
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right // вычисляем ширину изображения внутри ячейки путем вычитания левого и правого отступов
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) // метод который возвращает ячейку по идентификатору
        
        guard let imageListCell = cell as? ImagesListCell else { // чтобы работать с ячейкой как с экз класса ImageListCell проводим приведение типов
            return UITableViewCell() // возвращаем ячейку
        }

        configCell(for: imageListCell, with: indexPath) // вызываем метод конфигурации ячейки
        return imageListCell
    }
}

extension ImageListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) { // метод конфигурации ячейки
        guard let image = UIImage(named: photoName[indexPath.row]) else { // проверяем наличие изображения в масиве по индексу
            return
        }
        cell.cellImage.image = image // устанавливаем изображение в ячейку
        cell.cellImage.layer.cornerRadius = 16
        cell.cellImage.layer.masksToBounds = true
        
        cell.dateLabel.text = dateFormatter.string(from: Date()) // устанавливаем дату в ячейку

        let isLiked = indexPath.row % 2 == 0 // проверяем нравится ли картинка.
        let likeImage = isLiked ? UIImage(named: "active") : UIImage(named: "noActive") // данная переменная содержит ответ для кнопки в зависимости понравилась картинка или нет
        cell.likeButton.setImage(likeImage, for: .normal) // устанавливаем значение
    }
}

