import UIKit

enum HabitEditionState {
    case creation
    case edition
}


class HabitViewController: UIViewController {
    
    let store = HabitsStore.shared
    var currentHabit: Habit?
    var habitName: String?
    var habitEditionState = HabitEditionState.creation
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "НАЗВАНИЕ"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = Colors.blue
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.borderStyle = .none
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var colorSelectorLabel: UILabel = {
        let label = UILabel()
        label.text = "ЦВЕТ"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorSelectorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.orange
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(colorSelectButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "ВРЕМЯ"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var selectedTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Каждый день в"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeSelector: UIDatePicker = {
        let selector = UIDatePicker()
        selector.addTarget(self, action: #selector(timeSelectorAction(_:)), for: .valueChanged)
        selector.preferredDatePickerStyle = .wheels
        selector.datePickerMode = .time
        selector.timeZone = .autoupdatingCurrent
        selector.translatesAutoresizingMaskIntoConstraints = false
        return selector
    }()
    
    private lazy var deleteHabitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        return button
    }()
    
    @objc private func colorSelectButtonAction() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = colorSelectorButton.backgroundColor ?? .systemGray6
        colorPicker.delegate = self
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @objc private func timeSelectorAction(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        if let hour = components.hour, let minute = components.minute {
            selectedTimeLabel.text = "Каждый день в \(hour):\(minute)"
        }
    }
    
    @objc private func deleteButtonAction() {
        
        let alert = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \"\(String(describing: currentHabit!.name))?", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { action in
            
            self.deleteHabit(with: self.currentHabit!)
            let habitsController =  self.navigationController?.viewControllers.filter({$0 is HabitsViewController}).first
            self.navigationController?.popToViewController(habitsController!, animated: true)
            }
        ))
    }
    
    func deleteHabit(with habit: Habit) {
        store.habits.removeAll(where: {$0.name == habit.name})
    }
    
    private func layout() {
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(colorSelectorLabel)
        view.addSubview(colorSelectorButton)
        view.addSubview(timeLabel)
        view.addSubview(selectedTimeLabel)
        view.addSubview(timeSelector)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 120),
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
            nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nameTextField.widthAnchor.constraint(equalToConstant: 350),
            nameTextField.heightAnchor.constraint(equalToConstant: 22),
            
            colorSelectorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            colorSelectorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            colorSelectorLabel.widthAnchor.constraint(equalToConstant: 40),
            colorSelectorLabel.heightAnchor.constraint(equalToConstant: 18),
            
            colorSelectorButton.topAnchor.constraint(equalTo: colorSelectorLabel.bottomAnchor, constant: 7),
            colorSelectorButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            colorSelectorButton.widthAnchor.constraint(equalToConstant: 30),
            colorSelectorButton.heightAnchor.constraint(equalToConstant: 30),
            
            timeLabel.topAnchor.constraint(equalTo: colorSelectorButton.bottomAnchor, constant: 15),
            timeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            timeLabel.widthAnchor.constraint(equalToConstant: 50),
            timeLabel.heightAnchor.constraint(equalToConstant: 18),
            
            selectedTimeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            selectedTimeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            selectedTimeLabel.widthAnchor.constraint(equalToConstant: 200),
            selectedTimeLabel.heightAnchor.constraint(equalToConstant: 23),
            
            timeSelector.topAnchor.constraint(equalTo: selectedTimeLabel.bottomAnchor, constant: 15),
            timeSelector.leftAnchor.constraint(equalTo: view.leftAnchor),
            timeSelector.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        if habitEditionState == .edition {
            view.addSubview(deleteHabitButton)
            navigationItem.title = "Править"
            NSLayoutConstraint.activate([
            
                deleteHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
                deleteHabitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                deleteHabitButton.widthAnchor.constraint(equalToConstant: 170),
                deleteHabitButton.heightAnchor.constraint(equalToConstant: 22)])
            
            nameTextField.text = currentHabit?.name
            colorSelectorButton.backgroundColor = currentHabit?.color
            timeSelector.date = currentHabit!.date
            selectedTimeLabel.text = currentHabit?.dateString
        
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupNavigationBar() {
        if habitEditionState == .creation {
            navigationItem.title = "Создать"
        } else {
            navigationItem.title = "Править"
        }
        navigationController?.navigationBar.barTintColor = .systemGray6
        
        let returnButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(returnButtonAction))
        returnButton.tintColor = Colors.purple
        self.navigationItem.leftBarButtonItem = returnButton
        
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonAction))
        saveButton.tintColor = Colors.purple
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc private func returnButtonAction(_ sender: Any) {
        if habitEditionState == .creation {
        dismiss(animated: true, completion: nil)
        } else {
        navigationController?.popViewController(animated: true)
    }
    }
    
    @objc private func saveButtonAction() {
        if habitEditionState == .creation {
        let store = HabitsStore.shared
        let newHabit = Habit(name: nameTextField.text ?? "", date: timeSelector.date, color: colorSelectorButton.backgroundColor ?? .systemGray6)
        store.habits.append(newHabit)
        dismiss(animated: true, completion: nil)
        
        } else {
            
        let habitsController = self.navigationController?.viewControllers.filter({$0 is HabitsViewController}).first
        self.navigationController?.popToViewController(habitsController!, animated: true)

        store.habits.filter({$0.name == currentHabit?.name}).forEach({$0.name = nameTextField.text ?? ""})
        store.habits.filter({$0.date == currentHabit?.date}).forEach({$0.date = timeSelector.date})
        store.habits.filter({$0.color == currentHabit?.color}).forEach({$0.color = colorSelectorButton.backgroundColor ?? .black})
        store.save()
    }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        setupNavigationBar()
        hideKeyboardWhenTappedAround()
    }
    
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorSelectorButton.backgroundColor = viewController.selectedColor
    }
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorSelectorButton.backgroundColor = viewController.selectedColor
    }
}
