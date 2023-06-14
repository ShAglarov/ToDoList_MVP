//
//  Note.swift
//  ToDoList_MVP_Architecture
//
//  Created by Shamil Aglarov on 15.06.2023.
//

import Foundation

import Foundation

// MARK: - Note
// Модель для представления заметки в приложении. Соответствует стандартам Codable, Identifiable и Equatable.
struct Note: Codable, Identifiable, Equatable {

    // MARK: - Свойства
    var id = UUID()
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?

    // MARK: - Инициализация
    // Создание нового экземпляра заметки с указанными свойствами.
    init(id: UUID = UUID(),
         title: String,
         isComplete: Bool,
         dueDate: Date,
         notes: String? = nil) {
        self.id = id
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }
    
    // Создание нового экземпляра заметки на основе модели представления заметки.
    init(from viewModel: NoteViewModel) {
        self.id = viewModel.id
        self.title = viewModel.title
        self.isComplete = viewModel.isComplete
        self.dueDate = viewModel.dueDate
        self.notes = viewModel.notes
    }
    
    // MARK: - Функции
    // Функция для сравнения двух заметок.
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Note (Расширение)
extension Note {
    // Инициализация заметки на основе сущности заметки.
    init(from entity: NoteEntity) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? ""
        self.isComplete = entity.isComplete
        self.dueDate = entity.dueDate ?? Date()
        self.notes = entity.notes ?? ""
    }
}
