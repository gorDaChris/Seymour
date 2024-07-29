class Tag {
  final String displayName;
  final bool artwork;
  bool filtered;

  Tag(
    {
      required this.displayName, 
      required this.filtered, 
      required this.artwork
    }
  );

  void setFiltered(bool b) {
    filtered = b;
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      displayName: json['displayName'],
      filtered: json['filtered'],
      artwork: json['artwork'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'filtered': filtered,
      'artwork': artwork
    };
  }


  @override
  String toString() {
    return '{ "name": "$displayName", "filtered": "$filtered", "artwork": "$artwork" }';
  }
}