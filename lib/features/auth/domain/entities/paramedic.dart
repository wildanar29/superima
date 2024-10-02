class Paramedic {
  final String paramedicID;
  final String paramedicName;
  // final String paramedicType;

  Paramedic({
    required this.paramedicID,
    required this.paramedicName,
    // required this.paramedicType,
  });

  factory Paramedic.fromJson(Map<String, dynamic> json) {
    return Paramedic(
      paramedicID: json['paramedicid'],
      paramedicName: json['paramedicname'],
      // paramedicType: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paramedicID': paramedicID,
      'paramedicName': paramedicName,
      // 'paramedicType': paramedicType,
    };
  }
}
