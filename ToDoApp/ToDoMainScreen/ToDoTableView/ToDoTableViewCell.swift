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
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 1
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
        selectionStyle = .none
        [statusButton, titleLabel, descriptionLabel, dateLabel].forEach{
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
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(title: String, description: String, done: Bool) {
        titleLabel.attributedText = makeAttributedText(text: title, isDone: done, font: UIFont.systemFont(ofSize: 16, weight: .semibold))
        descriptionLabel.text = description
        isDone = done
        dateLabel.text = "09/10/24"
        updateIcon()
        updateTextColor()
    }
    
    private func makeAttributedText(text: String, isDone: Bool, font: UIFont) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .strikethroughStyle: isDone ? NSUnderlineStyle.single.rawValue : 0
        ]
        return NSAttributedString(string: text, attributes: attributes)
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
        isDone.toggle()
        updateIcon()
        updateTextColor()
        toggleCompletion?()
    }
}
