// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct AddressContainer: Decodable {
    let meta: Meta
    let documents: [Document]
}

struct Meta: Codable {
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}

struct Document: Decodable {
    let roadAddress: RoadAddress?
    let address: Address?

    enum CodingKeys: String, CodingKey {
        case roadAddress = "road_address"
        case address
    }
}

struct Address: Decodable {
    let addressName: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthName: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
    }
    
    var customAddress: String {
        return "\(region1DepthName) \(region2DepthName) \(region3DepthName)"
    }
}

struct RoadAddress: Decodable {
    let addressName: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthName: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
    }
}

