import UIKit
import SnapKit

class RecentBookCell: UICollectionViewCell {
    static let identifier = "RecentBookCell"
    
    private let bookImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    private func configureUI() {
        contentView.backgroundColor = .gray
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    private func setConstraints() {
        contentView.addSubview(bookImage)
        bookImage.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
            $0.height.equalTo(150)
            $0.width.equalTo(105)
        }
    }
    
    // 이미지 설정 메서드
    func configure(with imageUrl: String?) {
        // 이미지를 기본값으로 초기화
        self.bookImage.image = nil

        if let urlString = imageUrl, let url = URL(string: urlString) {
            // 비동기로 이미지 로딩
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.bookImage.image = image
                    }
                }
            }
        } else {
            self.bookImage.image = UIImage(systemName: "book")
        }
    }
}
