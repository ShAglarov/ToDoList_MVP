//
//  RealSaveNotesUseCase.swift
//  ToDoList_MVP_Architecture
//
//  Created by Shamil Aglarov on 15.06.2023.
//

import Foundation

import Foundation

// MARK: - SaveNotesUseCase Протокол
// Протокол, определяющий методы, необходимые для сохранения заметок.
protocol SaveNotesUseCase {
    // Метод, используемый для сохранения заметок
    func execute(notes: [Note], completion: @escaping (Result<Void, Error>) -> Void) // Функция выполнения, принимающая массив заметок и возвращающая результат сохранения или ошибку.
}

// MARK: - RealSaveNotesUseCase
// Класс, который реализует SaveNotesUseCase протокол.
class RealSaveNotesUseCase: SaveNotesUseCase {
    // Ссылка на репозиторий, который используется для сохранения заметок.
    private let repository: NoteRepositoryProtocol
    
    // Инициализатор класса
    init(repository: NoteRepositoryProtocol) { // Принимает репозиторий как параметр
        self.repository = repository
    }
    
    // MARK: - Метод execute
    // Реализация функции execute из протокола SaveNotesUseCase
    func execute(notes: [Note], completion: @escaping (Result<Void, Error>) -> Void) {
        // Вызов функции saveNotes из репозитория и передача заметок и completion handler
        repository.saveNotes(notes: notes, completion: completion)
    }
}
