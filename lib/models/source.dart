class Source {
  final String id;
  final String name;

  Source(
    this.id,
    this.name,
  );

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(json["id"].toString(), json["name"].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }

  static List<Source> parseList(List<dynamic> list) {
    return list.map((e) => Source.fromJson(e)).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Source && id == other.id && name == other.name;

  @override
  int get hashCode => Object.hash(id, name);
}
