import 'dart:convert';

BasicData basicDataFromJson(Map<String, dynamic> json) =>
    BasicData.fromJson(json);

String basicDataToJson(BasicData data) => json.encode(data.toJson());

class BasicData {
  BasicData({
    required this.name,
    required this.url,
  });

  String name;
  String url;

  factory BasicData.fromJson(Map<String, dynamic> json) => BasicData(
        name: json["name"].toString()[0].toUpperCase() +
            json["name"]
                .toString()
                .substring(1, json["name"].toString().length),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}
