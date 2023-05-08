class NutritionalInformation {
  final dynamic chocdf;
  final dynamic enercKcal;
  final dynamic fat;
  final dynamic fibtg;
  final dynamic procnt;

  NutritionalInformation({
    required this.chocdf,
    required this.enercKcal,
    required this.fat,
    required this.fibtg,
    required this.procnt,
  });

  factory NutritionalInformation.fromJson(Map<String, dynamic> json) {
    return NutritionalInformation(
      chocdf: json['CHOCDF'],
      enercKcal: json['ENERC_KCAL'],
      fat: json['FAT'],
      fibtg: json['FIBTG'],
      procnt: json['PROCNT'],
    );
  }

  static Map<String, dynamic> toJson(NutritionalInformation nutritionalInformation) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CHOCDF'] = nutritionalInformation.chocdf;
    data['ENERC_KCAL'] = nutritionalInformation.enercKcal;
    data['FAT'] = nutritionalInformation.fat;
    data['FIBTG'] = nutritionalInformation.fibtg;
    data['PROCNT'] = nutritionalInformation.procnt;
    return data;
  }

}
