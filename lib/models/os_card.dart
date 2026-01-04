
class OSCard {
  final String id;
  final String title;
  final String identityLaw;
  final String why;
  final String daily;
  final String weekly;
  final String excuse;
  final String rebuttal;
  final String mantra;

  OSCard({
    required this.id,
    required this.title,
    required this.identityLaw,
    required this.why,
    required this.daily,
    required this.weekly,
    required this.excuse,
    required this.rebuttal,
    required this.mantra,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'identityLaw': identityLaw,
        'why': why,
        'daily': daily,
        'weekly': weekly,
        'excuse': excuse,
        'rebuttal': rebuttal,
        'mantra': mantra,
      };

  factory OSCard.fromJson(Map<String, dynamic> json) => OSCard(
        id: json['id'],
        title: json['title'],
        identityLaw: json['identityLaw'],
        why: json['why'],
        daily: json['daily'],
        weekly: json['weekly'],
        excuse: json['excuse'],
        rebuttal: json['rebuttal'],
        mantra: json['mantra'],
      );
}
