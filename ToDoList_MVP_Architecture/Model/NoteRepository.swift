//
//  NoteRepository.swift
//  ToDoList_MVP_Architecture
//
//  Created by Shamil Aglarov on 15.06.2023.
//

// MARK: - Импорт библиотек

import Foundation

// MARK: - Протокол репозитория заметок

protocol NoteRepositoryProtocol {
    /// Получение списка заметок. Если заметки отсутствуют в кеше, они загружаются из сервиса.
    func getNotes(completion: @escaping (Result<[Note], Error>) -> Void)
    
    /// Сохранение списка заметок. Заметки сохраняются как в сервисе, так и в кеше.
    func saveNotes(notes: [Note], completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - Реализация репозитория заметок

final class NoteRepository: NoteRepositoryProtocol {
    
    private var service: ServiceProtocol
    private var cache: CacheProtocol
    
    /// Инициализация репозитория с передачей сервиса и кеша.
    init(service: ServiceProtocol, cache: CacheProtocol) {
        self.service = service
        self.cache = cache
    }
    
    /// Получение списка заметок из кеша или, при его отсутствии, из сервиса.
    func getNotes(completion: @escaping (Result<[Note], Error>) -> Void) {
        cache.getNotes { result in
            switch result {
            case .success(let cachedNotes):
                // Если кеш не пуст, возвращаем данные из кеша
                if !cachedNotes.isEmpty {
                    completion(.success(cachedNotes))
                } else {
                    // Если кеш пуст, загружаем данные из сервиса
                    self.loadNotesFromService(completion: completion)
                }
            case .failure:
                // Если пришла ошибка при загрузке из кеша, загружаем данные из сервиса
                self.loadNotesFromService(completion: completion)
            }
        }
    }
    
    /// Сохранение списка заметок в сервисе и кеше.
    func saveNotes(notes: [Note], completion: @escaping (Result<Void, Error>) -> Void) {
        service.saveData(notes: notes) { result in
            switch result {
            case .success:
                // Если сохранение в сервисе прошло успешно, сохраняем данные в кеше
                self.cache.saveNotes(notes: notes, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Вспомогательные методы
    
    /// Загрузка списка заметок из сервиса и сохранение их в кеше.
    private func loadNotesFromService(completion: @escaping (Result<[Note], Error>) -> Void) {
        service.getNotes { result in
            switch result {
            case .success(let notes):
                self.cache.saveNotes(notes: notes) { result in
                    if case .failure(let error) = result {
                        print("Error while saving notes: \(error)")
                    }
                    // Возвращаем данные из сервиса, даже если сохранение в кеше прошло неудачно
                    completion(.success(notes))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
