//
//  ToDoTableViewCell.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 01.08.2025.
//

import Foundation
import UIKit

final class ToDoTableViewCell: UITableViewCell {
    static let reuseIdentifier = "toDoCell"
    
    private var isDone: Bool = false
    var toggleCompletion: (() -> Void)?
    
    let statusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        statusButton.addTarget(self, action: #selector(toggleStatus), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black
        selectionStyle = .default
        [statusButton, titleLabel, descriptionLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            statusButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            statusButton.heightAnchor.constraint(equalToConstant: 24),
            statusButton.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34)
        ])
    }
    
    func configure(title: String, description: String, done: Bool) {
        titleLabel.text = title
        descriptionLabel.text = description
        isDone = done
        updateIcon()
        updateTextColor()
    }
    
    private func updateIcon() {
        let iconName = isDone ? "done" : "not done"
        statusButton.setImage(UIImage(named: iconName), for: .normal)
    }
    
    private func updateTextColor() {
        let color = isDone ? UIColor.gray : UIColor.white
        titleLabel.textColor = color
        descriptionLabel.textColor = color
    }
    
    @objc func toggleStatus() {
        //здесь переключаем картинку, меняем цвет шрифта в лейблах
        isDone.toggle()
        updateIcon()
        updateTextColor()
    }
}
