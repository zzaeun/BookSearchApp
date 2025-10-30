import UIKit

enum Section: Int, CaseIterable {
    case searchBar  // 검색바가 들어갈 섹션
    case recentBooks  // 최근 본 책 섹션
    case searchResults  // 검색 결과 리스트가 들어갈 섹션
}

// 검색 결과 셀
// 검색 결과 아이템 (제목 + 텍스트 필드)
class SearchResultCell: UICollectionViewCell {

    static let identifier = "SearchResultCell"
    
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
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
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail  // 길면 뒤에 ... 처리
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        authorLabel.layer.cornerRadius = 20
        authorLabel.font = .systemFont(ofSize: 14, weight: .regular)
        authorLabel.textColor = .gray
        authorLabel.textAlignment = .center
        authorLabel.numberOfLines = 1
        authorLabel.lineBreakMode = .byTruncatingTail  // 길면 뒤에 ... 처리
        authorLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        authorLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        priceLabel.font = .systemFont(ofSize: 16, weight: .regular)
        priceLabel.textAlignment = .right
        priceLabel.numberOfLines = 1
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        priceLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    func setConstraints() {
        
        let hStack = UIStackView(arrangedSubviews: [titleLabel, authorLabel, priceLabel])
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.alignment = .center
        hStack.distribution = .fill
        
        hStack.setCustomSpacing(10, after: authorLabel)  // authorLabel 뒤에 spacing 10
        
        hStack.layer.borderWidth = 1
        hStack.layer.borderColor = UIColor.black.cgColor
        hStack.layer.cornerRadius = 10
        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        
        contentView.addSubview(hStack)
        
        hStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
            $0.height.equalTo(60)
            $0.width.equalTo(280)
        }
    }
    
    // 데이터를 받아 셀 업데이트
    func configure(with title: String, author: String, price: String) {
        titleLabel.text = title
        authorLabel.text = author
        priceLabel.text = price
    }
}
