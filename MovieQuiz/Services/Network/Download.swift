//
//  Download.swift
//  MovieQuiz
//
//  Created by Sergey on 10.10.2022.
//

import Foundation
import UIKit

class Download {
    private var network: NetworkRouting

    init(network: NetworkRouting = NetworkClient()) {
        self.network = network
    }

    /// Скачивает и вовращает в случае успеха изображение
    func image(url: String, handle: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: url) else {
            return handle(.failure(DownloadError.invalidUrl))
        }

        self.network.get(url: url) { result in
            switch result {
            case.success(let image):
                guard let image = UIImage(data: image) else {
                    return handle(
                        .failure(
                            DownloadError.imageException("Неудалось создать изображение.")
                        ))
                }

                handle(.success(image))
            case .failure:
                handle(
                    .failure(
                        DownloadError.imageException("Неудалось загрузить изображение.")
                    ))
            }
        }
    }
}
