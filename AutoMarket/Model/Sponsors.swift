import Foundation

// MARK: - Ss
struct Sponsors: Codable {
    let result: [Result]
}

// MARK: - Result
struct Result: Codable {
    let id: Int
    let name: String
    let images: [Image]
}

// MARK: - Image
struct Image: Codable {
    let id, sponsorID: Int
    let image: String
    let mapImage: String?
    let active: Int
    let createdAt, updatedAt: String
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case sponsorID = "sponsor_id"
        case image
        case mapImage = "map_image"
        case active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

//// MARK: - Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}

