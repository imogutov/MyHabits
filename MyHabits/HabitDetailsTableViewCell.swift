import UIKit

class HabitDetailsTableViewCell: UITableViewCell {

    lazy var activityDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.addSubview(activityDayLabel)
        
        NSLayoutConstraint.activate([
            activityDayLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            activityDayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11),
            activityDayLabel.widthAnchor.constraint(equalToConstant: 150),
            activityDayLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
