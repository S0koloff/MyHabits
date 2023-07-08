//
//  HabitCreateViewController.swift
//  MyHabits
//
//  Created by Sokolov on 02.07.2023.
//

import UIKit

final class HabitCreateViewController: UIViewController {
    
    let habitsDataManager: HabitsDataManager
    
    init(habitsDataManager: HabitsDataManager) {
        self.habitsDataManager = habitsDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var id = UUID().uuidString
    
    // Custom Navigation
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton(frame: .zero)
        backButton.setTitle("Отменить", for: UIControl.State.normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 17)
        backButton.addTarget(self, action: #selector(self.didTapCloseButton), for: .touchUpInside)
        backButton.setTitleColor(Colors.purple, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton(frame: .zero)
        saveButton.setTitle("Сохранить", for: UIControl.State.normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17)
        saveButton.addTarget(self, action: #selector(self.didTapSaveButton), for: .touchUpInside)
        saveButton.setTitleColor(Colors.purple, for: .normal)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        return saveButton
    }()
    
    private lazy var titleV: UILabel = {
        let title = UILabel()
        title.text = "Создать"
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    //Layout
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        nameLabel.text = "НАЗВАНИЕ"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.font = .systemFont(ofSize: 17, weight: .semibold)
        nameTextField.autocapitalizationType = .none
        nameTextField.backgroundColor = .white
        nameTextField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()
    
    private lazy var colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        colorLabel.text = "ЦВЕТ"
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        return colorLabel
    }()
    
    private lazy var setColor: UIButton = {
        let setColor = UIButton()
        setColor.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
        setColor.addTarget(self, action: #selector(self.changeColor), for: .touchUpInside)
        setColor.isHidden = true
        setColor.alpha = 0
        setColor.translatesAutoresizingMaskIntoConstraints = false
        return setColor
    }()
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        timeLabel.text = "ВРЕМЯ"
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeLabel
    }()
    
    private lazy var timeTextLabel: UILabel = {
        let timeTextLabel = UILabel()
        timeTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        timeTextLabel.text = "Каждый день в"
        timeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeTextLabel
    }()
    
    private lazy var setTime: UITextField = {
        let setTime = UITextField()
        setTime.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        setTime.text = "11:40"
        setTime.translatesAutoresizingMaskIntoConstraints = false
        setTime.textColor = Colors.purple
        return setTime
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        setupView()
        setupGesture()
        setupPicker()
    }
    
    private func setupView() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.saveButton)
        self.view.addSubview(self.titleV)
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.nameTextField)
        self.view.addSubview(self.colorLabel)
        self.view.addSubview(self.setColor)
        self.view.addSubview(self.timeLabel)
        self.view.addSubview(self.timeTextLabel)
        self.view.addSubview(self.setTime)
        
        NSLayoutConstraint.activate([
            
            // MARK: - Custom NAvigation
            self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 55),
            self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            
            self.saveButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 55),
            self.saveButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            self.titleV.centerYAnchor.constraint(equalTo: self.saveButton.centerYAnchor),
            self.titleV.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            // MARK: - Layout
            
            self.nameLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 21),
            self.nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16),
            
            self.nameTextField.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 7),
            self.nameTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16),
            
            self.colorLabel.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 18),
            self.colorLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16),
            
            self.setColor.topAnchor.constraint(equalTo: self.colorLabel.bottomAnchor,constant: 7),
            self.setColor.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.setColor.rightAnchor.constraint(equalTo: self.view.leftAnchor,constant: 50),
            
            self.timeLabel.topAnchor.constraint(equalTo: self.setColor.bottomAnchor, constant: 18),
            self.timeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16),
            
            self.timeTextLabel.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 7),
            self.timeTextLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16),
            
            self.setTime.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 7),
            self.setTime.leftAnchor.constraint(equalTo: self.timeTextLabel.rightAnchor, constant: 5)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.kbSHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.setColor.layer.cornerRadius = 0.5 * self.setColor.bounds.size.width
            self.setColor.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.setColor.alpha = 1
            }, completion:  nil)
        }
        nameTextField.textColor = setColor.backgroundColor
        nameTextField.becomeFirstResponder()
    }
    
    private func setupPicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        setTime.inputView = datePicker
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        print(datePicker.date)
        setTime.text = formatDate(date: datePicker.date)
    }
    
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(kbSHide))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func kbSHide() {
        
        self.view.endEditing(true)
    }
    
    @objc func changeColor () {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.setColor.backgroundColor!
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    
    
    @objc func didTapCloseButton(){
        dismiss(animated: true)
    }
    
    @objc func didTapSaveButton(){
        habitsDataManager.createHabit(id: id, name: nameTextField.text ?? "", time: setTime.text ?? "", completed: false, sum: 0, color: setColor.backgroundColor ?? .green) {
            DispatchQueue.main.async { [self] in
                habitsDataManager.saveContext()
                habitsDataManager.reloadHabits()
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "habitsUpdate"), object: nil)
        }
        dismiss(animated: true)
    }
    
}

extension HabitCreateViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ setColor: UIColorPickerViewController) {
        self.setColor.backgroundColor = setColor.selectedColor
        self.nameTextField.textColor = self.setColor.backgroundColor

    }
    
    func colorPickerViewControllerDidSelectColor(_ setColor: UIColorPickerViewController) {
        self.setColor.backgroundColor = setColor.selectedColor
    }
}
