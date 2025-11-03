import UIKit

// SearchBar 섹션의 아이템으로 사용
// UISearchBar를 담기 위함
class SearchCell: UICollectionViewCell {
    // 이 셀의 재사용 식별자
    static let identifier = "SearchCell"
    
    let searchBar = UISearchBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        searchBar.placeholder = "책 이름을 검색해주세요"
        searchBar.layer.cornerRadius = 10
        searchBar.backgroundImage = UIImage()  // 경계선 안보이게 하려고
    }
    
    private func setConstraints() {
        [searchBar].forEach{ contentView.addSubview($0) }
        searchBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
