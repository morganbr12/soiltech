class JsonMap {
  final Map<String, dynamic> _map;

  const JsonMap(this._map);

  factory JsonMap.fromJson(Map<String, dynamic> json) => JsonMap(json);

  dynamic operator [](String key) => _map[key];

  Map<String, dynamic> toJson() => _map;
}
