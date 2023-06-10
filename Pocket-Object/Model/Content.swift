import Foundation
import SwiftData

@Model
class Content {
    /// Primary Key
    @Attribute(.unique) var id: UUID
    /// 이미지 경로
    var imageUrl: String
    /// 최종 수정일
    var date: Date
    /// 제목
    var title: String
    /// 컨텐츠
    var content: String
    /// 위도
    var lat: String
    /// 경도
    var log: String
    /// 즐겨 찾기
    var bookmark: Bool

    init(id: String, imageUrl: String, date: Date, title: String, content: String, lat: String, log: String, bookmark: Bool) {
        self.id = UUID()
        self.imageUrl = imageUrl
        self.date = date
        self.title = title
        self.content = content
        self.lat = lat
        self.log = log
        self.bookmark = bookmark
    }
}
