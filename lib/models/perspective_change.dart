class PerspectiveChangeModel {
  final String id;
  final String dont;
  final String say;
  final String aim;
  final bool isCustom;
  final bool isDefault;

  PerspectiveChangeModel({
    required this.id,
    required this.dont,
    required this.say,
    required this.aim,
    this.isCustom = false,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'dont': dont,
        'say': say,
        'aim': aim,
        'isCustom': isCustom,
        'isDefault': isDefault,
      };

  factory PerspectiveChangeModel.fromJson(Map<String, dynamic> json) => PerspectiveChangeModel(
        id: json['id'],
        dont: json['dont'],
        say: json['say'],
        aim: json['aim'],
        isCustom: json['isCustom'] ?? false,
        isDefault: json['isDefault'] ?? false,
      );

  PerspectiveChangeModel copyWith({
    String? id,
    String? dont,
    String? say,
    String? aim,
    bool? isCustom,
    bool? isDefault,
  }) {
    return PerspectiveChangeModel(
      id: id ?? this.id,
      dont: dont ?? this.dont,
      say: say ?? this.say,
      aim: aim ?? this.aim,
      isCustom: isCustom ?? this.isCustom,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
