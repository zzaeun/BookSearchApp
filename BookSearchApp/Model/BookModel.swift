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
}
