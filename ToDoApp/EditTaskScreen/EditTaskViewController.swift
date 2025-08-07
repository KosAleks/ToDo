//
//  EditTaskViewController.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 07.08.2025.
//

import Foundation
import UIKit

import UIKit

protocol EditTaskViewProtocol: AnyObject {
    
}

final class EditTaskViewController: UIViewController {
    
    var presenter: EditTaskPresenterProtocol!
    
    // MARK: - UI
    
    let titleTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .black
        tv.textColor = .white
        tv.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        tv.layer.cornerRadius = 8
        tv.text = "Заняться спортом"
        return tv
    }()
    
    let dateTextField: UITextField = {
        let tf = UITextField()
        tf.text = getTodayDateString()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        tf.backgroundColor = .black
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.tintColor = .yellow
        picker.locale = Locale(identifier: "ru_RU") 
        return picker
    }()
    
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .black
        tv.textColor = .white
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.cornerRadius = 8
        tv.text = "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике."
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupLayout()
        setupDatePicker()
        presenter.viewDidLoad()
    }
    
    private func setupLayout() {
        [titleTextView, dateTextField, descriptionTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextView.heightAnchor.constraint(equalToConstant: 50),
            
            dateTextField.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
            dateTextField.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            dateTextField.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
            dateTextField.heightAnchor.constraint(equalToConstant: 16),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateTextField.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = .gray
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(donePressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([space, doneButton], animated: false)
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc private func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        
        let selectedDate = formatter.string(from: datePicker.date)
        dateTextField.text = selectedDate
        view.endEditing(true)
    }
}
