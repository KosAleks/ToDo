//
//  EditTaskViewController.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 07.08.2025.
//

import Foundation
import UIKit

protocol EditTaskViewProtocol: AnyObject {
    
}
final class EditTaskViewController: UIViewController, EditTaskViewProtocol {
    var onTaskUpdated: (() -> Void)?
    var presenter: EditTaskPresenterProtocol?
    var task: Task?
    
    let titleTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .black
        tv.textColor = .white
        tv.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        tv.isScrollEnabled = false
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        return tv
    }()
    
    let dateTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .gray
        tf.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        tf.backgroundColor = .black
        return tf
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.tintColor = .systemYellow
        picker.locale = Locale(identifier: "ru_RU")
        return picker
    }()
    
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .black
        tv.textColor = .white
        tv.textAlignment = .justified
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupBackButton()
        setupLayout()
        setupDatePicker()
        fillData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func fillData() {
        guard let task = task else { return }
        let todayDate = getTodayDateString()
        titleTextView.text = task.description
        descriptionTextView.text = task.description
        dateTextField.text = todayDate
    }
    
    private func setupLayout() {
        [backButton, titleTextView, dateTextField, descriptionTextView].forEach {($0).translatesAutoresizingMaskIntoConstraints = false }
        [backButton, titleTextView, dateTextField, descriptionTextView].forEach {view.addSubview($0) }
        let safeTop = view.safeAreaLayoutGuide.topAnchor
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: safeTop, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 81),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            titleTextView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            titleTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            dateTextField.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 8),
            dateTextField.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            dateTextField.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
            dateTextField.heightAnchor.constraint(equalToConstant: 10),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 66)
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
    
    private func setupBackButton() {
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle("Назад", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.tintColor = UIColor(named: "yellowColor")
        backButton.setTitleColor(UIColor(named: "yellowColor"), for: .normal)
        backButton.contentMode = .scaleToFill
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        
        if let imageView = backButton.imageView {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 17),
                imageView.heightAnchor.constraint(equalToConstant: 22)
            ])
        }
        
        if let titleLabel = backButton.titleLabel {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.widthAnchor.constraint(equalToConstant: 50),
                titleLabel.heightAnchor.constraint(equalToConstant: 22)
            ])
        }
    }
    
    func makeDateFromString(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
    }
    
    func makeStringFromDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.string(from: date)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    
    @objc private func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        let selectedDate = formatter.string(from: datePicker.date)
        dateTextField.text = selectedDate
        view.endEditing(true)
    }
    
    @objc private func backTapped() {
        let dateString = dateTextField.text ?? getTodayDateString()
        let date = makeDateFromString(from: dateString) ?? Date()
        
        presenter?.saveTaskChanges(
            title: titleTextView.text,
            id: Int32(task?.id ?? 0),
            todo: descriptionTextView.text,
            date: date
        ) {
            self.onTaskUpdated?()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
