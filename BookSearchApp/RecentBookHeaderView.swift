import UIKit
import SnapKit

class RecentBookHeaderView: UICollectionReusableView {
    static let identifier = "RecentBookHeaderView"
    
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        title.font = .systemFont(ofSize: 26, weight: .bold)
    }
    
    private func setConstraints() {
        [title].forEach { addSubview($0) }
        title.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview()
        }
    }
}
