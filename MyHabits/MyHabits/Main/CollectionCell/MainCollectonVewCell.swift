//
//  MainCollectonVewCell.swift
//  MyHabits
//
//  Created by Sokolov on 02.07.2023.
//
import UIKit

protocol MainCollectonProtocol {
    func habitComplited(id: String)
    func checkComplited(id: String) -> Bool
    func deleteHabit(id: String)
    func reload()
}

final class MainCollectionViewCell: UICollectionViewCell {
    
    var delegate: MainCollectonProtocol?
    var id = ""
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        timeLabel.textColor = .systemGray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeLabel
    }()
    
    private lazy var scoreLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        scoreLabel.textColor = .systemGray
        scoreLabel.text = "Счетчик: "
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        return scoreLabel
    }()
    
    private lazy var sum: UILabel = {
        let sum = UILabel()
        sum.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        sum.textColor = .systemGray
        sum.translatesAutoresizingMaskIntoConstraints = false
        return sum
    }()
    
    private lazy var acceptButton: UIButton = {
        let acceptButton = UIButton()
        acceptButton.setImage(UIImage(named: "circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        acceptButton.contentMode = .scaleAspectFit
        acceptButton.addTarget(self, action: #selector(self.acceptTap), for: .touchUpInside)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        return acceptButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with habit: Habit) {
        nameLabel.text = habit.name
        timeLabel.text = "Каждый день в \(habit.time ?? "00:00")"
        id = habit.id ?? ""
        sum.text = "\(habit.sum)"
        acceptButton.tintColor = habit.color as? UIColor
        nameLabel.textColor = habit.color as? UIColor
//        self.acceptButton.layer.borderColor = habit.color.cgColor
    }
    
    private func setupView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(acceptButton)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(sum)
        
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            
            scoreLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 40),
            scoreLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            
            sum.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 40),
            sum.leftAnchor.constraint(equalTo: scoreLabel.rightAnchor),
            
            acceptButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            acceptButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25),
            acceptButton.widthAnchor.constraint(equalToConstant: 45),
            acceptButton.heightAnchor.constraint(equalToConstant: 45),
            
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        acceptButton.clipsToBounds = true
        let checkComplited = delegate?.checkComplited(id: self.id)
        if checkComplited == true {
            acceptButton.setImage(UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            acceptButton.setImage(UIImage(named: "circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        acceptButton.contentMode = .scaleAspectFit
//        acceptButton.tintColor = getColor
//        if acceptButton.tintColor != UIColor.systemGray2 {
//            acceptButton.setImage(UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        } else {
//            acceptButton.setImage(UIImage(named: "circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        }
    }
    
    private func setupGesture() {
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(self.longAction(_:)))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(longTap)
    }
    
    @objc func longAction(_ sender: UILongPressGestureRecognizer) {
        
        self.delegate?.deleteHabit(id: self.id)
    }
    
    @objc func acceptTap() {
        delegate?.habitComplited(id: self.id)
    }
    
}
