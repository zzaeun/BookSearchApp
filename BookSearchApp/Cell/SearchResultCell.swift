import UIKit

enum Section: CaseIterable {
    case searchBar  // 검색바가 들어갈 섹션
    case searchResults  // 검색 결과 리스트가 들어갈 섹션
}

// 검색 결과 셀
// 검색 결과 아이템 (제목 + 텍스트 필드)
class SearchResultCell: UICollectionViewCell {

    static let identifier = "SearchResultCell"
    
    private let titleLabel = UILabel()
    private let bookDetailLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        bookDetailLabel.layer.cornerRadius = 20
        bookDetailLabel.font = .systemFont(ofSize: 16, weight: .regular)
        bookDetailLabel.textColor = .gray
        
        priceLabel.font = .systemFont(ofSize: 16, weight: .regular)
    }
    
    func setConstraints() {
        
        let hStack = UIStackView(arrangedSubviews: [titleLabel, bookDetailLabel, priceLabel])
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.alignment = .center
        
        contentView.addSubview(hStack)
        
        hStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
    
    // 데이터를 받아 셀 업데이트
    func configure(with title: String, bookDetail: String, price: String) {
        titleLabel.text = title
        bookDetailLabel.text = bookDetail
        priceLabel.text = price
    }
}
