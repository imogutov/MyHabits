import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    private lazy var messageToUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Все получится!"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progressViewStyle = .default
        view.trackTintColor = .systemGray2
        view.progressTintColor = Colors.purple
        view.layer.cornerRadius = 3.5
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    private func layout() {
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
        
        contentView.addSubview(messageToUserLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(percentLabel)
        
        NSLayoutConstraint.activate([
            messageToUserLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageToUserLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            messageToUserLabel.widthAnchor.constraint(equalToConstant: 220),
            messageToUserLabel.heightAnchor.constraint(equalToConstant: 18),
            
            progressView.topAnchor.constraint(equalTo: messageToUserLabel.bottomAnchor, constant: 10),
            progressView.heightAnchor.constraint(equalToConstant: 7),
            progressView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            progressView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            
            percentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            percentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            percentLabel.widthAnchor.constraint(equalToConstant: 50),
            percentLabel.heightAnchor.constraint(equalToConstant: 18)
            
            ])
        
    }
    
    func setupProgress() {
        let store = HabitsStore.shared
        progressView.setProgress(store.todayProgress, animated: true)
        percentLabel.text = String(Int(store.todayProgress * 100.0)) + "%"
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
