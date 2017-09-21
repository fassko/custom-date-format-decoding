import Foundation

struct CustomDate: Decodable {
  let dateISO8601: Date
  let dateISO8601Milliseconds: Date
}

let json = """
{
 "dateISO8601": "2017-06-21T15:29:32Z",
 "dateISO8601Milliseconds": "2017-02-06T12:35:29.123Z"
}
""".data(using: .utf8)!

let dateISO8601Formatter = DateFormatter()
dateISO8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

let dateISO8601MillisecondsFormatter = DateFormatter()
dateISO8601MillisecondsFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

let decoder = JSONDecoder()

decoder.dateDecodingStrategy = .custom({decoder -> Date in
  
  let container = try decoder.singleValueContainer()
  let dateStr = try container.decode(String.self)
  
  // possible date strings: "yyyy-MM-dd'T'HH:mm:ssZ" or "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
  
  var tmpDate: Date? = nil
  
  if dateStr.count == 24 {
    tmpDate = dateISO8601MillisecondsFormatter.date(from: dateStr)
  } else {
    tmpDate = dateISO8601Formatter.date(from: dateStr)
  }
  
  guard let date = tmpDate else {
    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
  }
  
  return date
})

let data = try decoder.decode(CustomDate.self, from: json)
print(data)

print(dateISO8601MillisecondsFormatter.string(from: data.dateISO8601Milliseconds))
