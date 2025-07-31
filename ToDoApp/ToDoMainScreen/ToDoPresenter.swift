//
//  ToDoPresenter.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 31.07.2025.
//

import Foundation

protocol ToDoPresenterProtocol: AnyObject {
    func configueView()
}


class ToDoPresenter: ToDoPresenterProtocol {
    weak var view: ToDoViewProtocol?
    required init(view: ToDoViewProtocol) {
        self.view = view
        
    }
    
    func configueView() {
        print("")
    }

}
