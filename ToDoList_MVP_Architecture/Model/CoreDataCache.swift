//
//  CoreDataCache.swift
//  ToDoList_MVP_Architecture
//
//  Created by Shamil Aglarov on 15.06.2023.
//

import Foundation
import CoreData

// MARK: - Кэширование с использованием CoreData
protocol CacheProtocol {
    // Получение заметок из кэша
    func getNotes(completion: @escaping (Result<[Note], Error>) -> Void)
    // Сохранение заметок в кэш
    func saveNotes(notes: [Note], completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - Реализация протокола кэширования с использованием CoreData
class CoreDataCache: CacheProtocol {
    
    // CoreData Persistent Container
    private let persistentContainer: NSPersistentContainer
    
    // Инициализатор, принимающий контейнер CoreData
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    // Сохранение заметок в CoreData
    func saveNotes(notes: [Note], completion: @escaping (Result<Void, Error>) -> Void)  {
        let context = persistentContainer.viewContext
        
        for note in notes {
            let _ = NoteEntity(from: note, context: context)
        }
        
        do {
            try context.save()
            // При успешном сохранении вызывается success
            completion(.success(()))
        } catch {
            // При ошибке сохранения вызывается failure
            print("Ошибка при сохранении: \(error)")
            completion(.failure(error))
        }
    }
    
    // Получение заметок из CoreData
    func getNotes(completion: @escaping (Result<[Note], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest() as! NSFetchRequest<NoteEntity>
        do {
            let noteEntities = try persistentContainer.viewContext.fetch(fetchRequest)
            // При успешном получении вызывается success
            completion(.success(noteEntities.map { Note(from: $0) }))
        } catch {
            // При ошибке получения вызывается failure
            print("Ошибка при получении данных: \(error)")
            completion(.failure(error))
        }
    }
}
