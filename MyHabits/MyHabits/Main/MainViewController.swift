//
//  ViewController.swift
//  MyHabits
//
//  Created by Sokolov on 02.07.2023.
//

import UIKit
import ALProgressView
import CoreData

final class MainViewController: UIViewController {
    
    let habitsDataManager: HabitsDataManager
    
    init(habitsDataManager: HabitsDataManager) {
        self.habitsDataManager = habitsDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum Constants {
        static let numberOfItemsInLine: CGFloat = 1
    }
    
    // MARK: - Header
    
    private lazy var infoHeaderView: UIView = {
        let infoHeaderView = UIView()
        infoHeaderView.backgroundColor = .white
        infoHeaderView.translatesAutoresizingMaskIntoConstraints = false
        return infoHeaderView
    }()
    
    private lazy var infoHeaderTitle: UILabel = {
        let infoHeaderTitle = UILabel()
        infoHeaderTitle.text = MainText.titleHeader
        infoHeaderTitle.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        infoHeaderTitle.translatesAutoresizingMaskIntoConstraints = false
        return infoHeaderTitle
    }()
    
    private lazy var infoHeaderDescription: UILabel = {
        let infoHeaderDescription = UILabel()
        infoHeaderDescription.text = MainText.descriptionTextStart
        infoHeaderDescription.textColor = .systemGray2
        infoHeaderDescription.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        infoHeaderDescription.numberOfLines = 0
        infoHeaderDescription.translatesAutoresizingMaskIntoConstraints = false
        return infoHeaderDescription
    }()
    
    private lazy var progressRing = ALProgressRing()
    
    // MARK: - Collection
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupRing()
        setupNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: Notification.Name("habitsUpdate"), object: nil)
    }
    
    private func setupNavigationBar() {
        let button = UIButton()
        button.tintColor = UIColor(red: 0.63, green: 0.09, blue: 0.80, alpha: 1.00)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(plusButtomTapped), for: .touchUpInside)
        let plusBarItem = UIBarButtonItem(customView: button)
        
        let leftbutton = UIButton()
        leftbutton.tintColor = UIColor(red: 0.63, green: 0.09, blue: 0.80, alpha: 1.00)
        leftbutton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        leftbutton.addTarget(self, action: #selector(reloadButtomTapped), for: .touchUpInside)
        let reloadBarItem = UIBarButtonItem(customView: leftbutton)
        
        navigationItem.rightBarButtonItem = plusBarItem
        navigationItem.leftBarButtonItem = reloadBarItem
    }
    
    private func setupView() {
        view.addSubview(infoHeaderView)
        infoHeaderView.addSubview(infoHeaderTitle)
        infoHeaderView.addSubview(infoHeaderDescription)
        infoHeaderView.addSubview(progressRing)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            infoHeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            infoHeaderView.leftAnchor.constraint(equalTo: view.leftAnchor),
            infoHeaderView.rightAnchor.constraint(equalTo: view.rightAnchor),
            infoHeaderView.heightAnchor.constraint(equalToConstant: 115),
            
            infoHeaderTitle.topAnchor.constraint(equalTo: infoHeaderView.topAnchor, constant: 6),
            infoHeaderTitle.leftAnchor.constraint(equalTo: infoHeaderView.leftAnchor, constant: 16),
            
            infoHeaderDescription.topAnchor.constraint(equalTo: infoHeaderTitle.bottomAnchor, constant: 3),
            infoHeaderDescription.leftAnchor.constraint(equalTo: infoHeaderView.leftAnchor, constant: 16),
            infoHeaderDescription.rightAnchor.constraint(equalTo: progressRing.leftAnchor, constant: -5),
            infoHeaderDescription.bottomAnchor.constraint(equalTo: infoHeaderView.bottomAnchor, constant: -3),
            
            progressRing.centerYAnchor.constraint(equalTo: infoHeaderView.centerYAnchor),
            progressRing.rightAnchor.constraint(equalTo: infoHeaderView.rightAnchor, constant: -50),
            progressRing.widthAnchor.constraint(equalToConstant: 100),
            progressRing.heightAnchor.constraint(equalToConstant: 100),
            
            collectionView.topAnchor.constraint(equalTo: infoHeaderView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    private func setupDescriptionText() {
        DispatchQueue.main.async { [self] in
            if progressRing.progress == 0 {
                infoHeaderDescription.text = MainText.descriptionTextStart
            } else if progressRing.progress >= 0.1 && progressRing.progress < 1 {
                infoHeaderDescription.text = MainText.descriptionText
            } else if progressRing.progress == 1 {
                infoHeaderDescription.text = MainText.descriptionTextComplited
            }
        }
    }
    
    private func setupRing() {
        progressRing.translatesAutoresizingMaskIntoConstraints = false
        progressRing.startColor = UIColor(red: 0.63, green: 0.09, blue: 0.80, alpha: 1.00)
        
        let progress = UserDefaults.standard.float(forKey: "progressStatus")
        print("PROGRESS", progress)
        progressRing.setProgress(progress, animated: true)
        
        setupDescriptionText()
    }
    
    @objc private func plusButtomTapped() {
        let vc = HabitCreateViewController(habitsDataManager: habitsDataManager)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc private func reloadButtomTapped() {
        habitsDataManager.habits.forEach { habit in
            habit.completed = false
        }
        habitsDataManager.saveContext()
        habitsDataManager.reloadHabits()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "habitsUpdate"), object: nil)
    }
    
    @objc private func update() {
        var array = [Any]()
        habitsDataManager.habits.forEach { habit in
            if habit.completed == true {
                array.append(habit)
            }
        }
        let a = array.count
        let c = habitsDataManager.habits.count
        let v: Float = Float(a) / Float(c)
        DispatchQueue.main.async {
            self.progressRing.setProgress(Float(v), animated: true)
            self.collectionView.reloadData()
        }
        UserDefaults.standard.set(v, forKey: "progressStatus")
        print("OBSHEE KOL4ESTVO HABITS", habitsDataManager.habits.count)
        print("VIPONENE HABITS", array.count)
        let progress = UserDefaults.standard.float(forKey: "progressStatus")
        print("PROGRESS!!", progress)
        setupDescriptionText()
    }
}

extension MainViewController: MainCollectonProtocol {
    func habitComplited(id: String) {
        if let habit = habitsDataManager.habits.first(where: {$0.id == id}) {
            if habit.completed != true {
                habit.completed = true
                habit.sum += 1
                habitsDataManager.saveContext()
                habitsDataManager.reloadHabits()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "habitsUpdate"), object: nil)
                print("PROGRESS", progressRing.progress)
                
                
            } else {
                return
            }
        }
    }
    
    func checkComplited(id: String) -> Bool {
        var complited = false
        if let habit = habitsDataManager.habits.first(where: {$0.id == id}) {
            if habit.completed == true {
                complited = true
            } else {
                complited = false
            }
        }
        return complited
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    func deleteHabit(id: String) {
        
        let alertController = UIAlertController(title: "Удалить привычку?", message: "Привычка и счетчик ее выполнения будет удален", preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: "Удалить", style: .default) { [self] _ in
            if let habit = habitsDataManager.habits.first(where: {$0.id == id}) {
                habitsDataManager.deleteHabit(habit: habit)
                habitsDataManager.saveContext()
                habitsDataManager.reloadHabits()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "habitsUpdate"), object: nil)
            }
        }
        let secondAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
        }
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        self.present(alertController, animated: true)
    }
    
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        habitsDataManager.habits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let insets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let interItemSpacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
        
        let width = collectionView.frame.width - (Constants.numberOfItemsInLine - 1) * interItemSpacing - insets.left - insets.right
        let itemWidth = floor(width / Constants.numberOfItemsInLine)
        
        return CGSize(width: itemWidth, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainCollectionViewCell
        
        cell.delegate = self
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 6
        cell.alpha = 0.6
        cell.setup(with: habitsDataManager.habits[indexPath.row])
        UIView.animate(withDuration: 0.85, animations: {
            cell.alpha = 1
        }, completion:  nil)
        return cell
    }
}


