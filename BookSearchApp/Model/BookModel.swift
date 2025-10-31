import Foundation

struct BookResponse: Decodable {
    let documents: [Book]
}

struct Book: Decodable {
    let title: String
    let authors: [String]
    let price: Int
    let thumbnail: String?
    let contents: String
}

enum Section: Int, CaseIterable {
    case searchBar  // 검색바가 들어갈 섹션
    case recentBooks  // 최근 본 책 섹션
    case searchResults  // 검색 결과 리스트가 들어갈 섹션
    
    // 현재 표시되어야 하는 섹션의 목록을 반환하는 함수
    static func visibleSections(hasRecentBooks: Bool) -> [Section] {
        var sections: [Section] = [.searchBar]
        
        // 최근 본 책이 있을 때만 추가
        if hasRecentBooks {
            sections.append(.recentBooks)
        }
        sections.append(.searchResults)
        return sections
    }
}
