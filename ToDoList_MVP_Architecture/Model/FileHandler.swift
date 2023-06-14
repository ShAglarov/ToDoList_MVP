//
//  FileHandler.swift
//  ToDoList_MVP_Architecture
//
//  Created by Shamil Aglarov on 15.06.2023.
//

import Foundation

// MARK: - Протокол для работы с файлами
protocol FileHandlerProtocol {
    // Загрузка содержимого данных из файла
    func loadDataContent(completion: @escaping (Result<Data, Error>) -> Void)
    // Запись данных в файл
    func writeData(_ data: Data, completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - Реализация протокола для работы с файлами
class FileHandler: FileHandlerProtocol {
    
    private var url: URL
    
    init() {
        // Получаем URL директории для сохранения файла
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url = documentsDirectory.appendingPathComponent("todo").appendingPathExtension("plist")
        
        // Проверяем существует ли файл
        if !FileManager.default.fileExists(atPath: url.path) {
            // Если файла нет, создаем новый
            FileManager.default.createFile(atPath: url.path, contents: nil)
        }
    }
    
    // Загружаем содержимое файла в фоновом потоке
    func loadDataContent(completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                // Пытаемся загрузить данные
                let data = try Data(contentsOf: self.url)
                // В случае успеха возвращаем данные
                completion(.success(data))
            } catch {
                // В случае ошибки возвращаем описание ошибки
                print("Ошибка при чтении данных: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // Записываем данные в файл в фоновом потоке
    func writeData(_ data: Data, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                // Пытаемся записать данные
                try data.write(to: self.url)
                // В случае успеха возвращаем пустую успешную операцию
                completion(.success(()))
            } catch {
                // В случае ошибки возвращаем описание ошибки
                print("Ошибка при записи данных: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
