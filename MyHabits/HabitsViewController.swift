import UIKit

class HabitsViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabitCollectionViewCell.self))
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem()
        addButton.image = UIImage(systemName: "plus")
        addButton.style = .plain
        addButton.target = self
        addButton.action = #selector(openNewHabit)
        addButton.tintColor = Colors.purple
        return addButton
    }()
    
    @objc private func openNewHabit() {
        let habitVC = HabitViewController()
        let openHabitVC = UINavigationController(rootViewController: habitVC)
        openHabitVC.modalPresentationStyle = .fullScreen
        self.present(openHabitVC, animated: true, completion: nil)
    }
    
    private func layout() {
        view.backgroundColor = .systemGray6
        view.addSubview(collectionView)
        collectionView.backgroundColor = Colors.ligthGray
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Сегодня"
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.setStatusBar(backgroundColor: .white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        navigationItem.rightBarButtonItem = addButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction), name: NSNotification.Name.needToReloadCollectionView, object: nil)
    }
    
    @objc private func notificationAction() {
        collectionView.reloadData()
    }
}


extension HabitsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: ProgressCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self), for: indexPath) as! ProgressCollectionViewCell
            cell.setupProgress()
            return cell
        }
        let cell: HabitCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabitCollectionViewCell.self), for: indexPath) as! HabitCollectionViewCell
        let habit = HabitsStore.shared.habits[indexPath.row]
        cell.update(with: habit)
        cell.habitIsTaken = { [weak self] in
            if habit.isAlreadyTakenToday == false {
                HabitsStore.shared.track(habit)
            }
            self?.collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return HabitsStore.shared.habits.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 60)
        }
        return CGSize(width: UIScreen.main.bounds.width - 32, height: 130)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 22, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsController = HabitDetailsViewController()
        if indexPath.section != 0 {
            navigationController?.pushViewController(detailsController, animated: true)
        }
        let habit = HabitsStore.shared.habits[indexPath.row]
        detailsController.habitName = habit.name
        detailsController.currentHabit = habit
    }
}

extension NSNotification.Name {
    static let needToReloadCollectionView = NSNotification.Name("needToReloadCollectionView")
}


