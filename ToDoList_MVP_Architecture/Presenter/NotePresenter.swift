//
//  NotePresenter.swift
//  ToDoList_MVP_Architecture
//
//  Created by Shamil Aglarov on 15.06.2023.
//

import Foundation

// MARK: - NotePresenterProtocol
// Протокол, определяющий, как должен действовать презентер.
protocol NotePresenterProtocol {
    func viewDidLoad() // Функция вызывается при загрузке View.
    func saveNotes(notes: [NoteViewModel]) // Функция для сохранения заметок.
}

// MARK: - NotePresenter
// Класс, отвечающий за логику работы с заметками.
class NotePresenter: NotePresenterProtocol {
    
    // Слабая ссылка на View.
    private weak var view: NoteViewProtocol?
    
    // Use case для получения и сохранения заметок.
    private let getNotes: GetNotesUseCase
    private let saveNotes: SaveNotesUseCase

    // Инициализатор презентера.
    init(view: NoteViewProtocol, getNotes: GetNotesUseCase, saveNotes: SaveNotesUseCase) {
        self.view = view
        self.getNotes = getNotes
        self.saveNotes = saveNotes
    }

    // MARK: - Protocol Methods
    // Функция вызывается при загрузке View.
    func viewDidLoad() {
        getNotes.execute { [weak self] result in
            switch result {
            case .success(let notes):
                let viewModels = notes.map { NoteViewModel(from: $0) }
                self?.view?.displayNotes(with: viewModels) // Показываем заметки на View.
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription) // Показываем ошибку на View.
            }
        }
    }
    
    // Функция для сохранения заметок.
    func saveNotes(notes: [NoteViewModel]) {
        let notes = notes.map { Note(from: $0) }
        saveNotes.execute(notes: notes) { result in
            switch result {
            case .success:
                print("Заметки успешно сохранены") // Выводим сообщение об успешном сохранении заметок.
            case .failure(let error):
                print("Не удалось сохранить заметки, ошибка: \(error)") // Выводим сообщение об ошибке.
            }
        }
    }
}
