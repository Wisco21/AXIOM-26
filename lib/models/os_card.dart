// class OSCard {
//   final String id;
//   final String title;
//   final String identityLaw;
//   final String why;
//   final String daily;
//   final String weekly;
//   final String excuse;
//   final String rebuttal;
//   final String mantra;

//   OSCard({
//     required this.id,
//     required this.title,
//     required this.identityLaw,
//     required this.why,
//     required this.daily,
//     required this.weekly,
//     required this.excuse,
//     required this.rebuttal,
//     required this.mantra,
//   });

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'title': title,
//         'identityLaw': identityLaw,
//         'why': why,
//         'daily': daily,
//         'weekly': weekly,
//         'excuse': excuse,
//         'rebuttal': rebuttal,
//         'mantra': mantra,
//       };

//   factory OSCard.fromJson(Map<String, dynamic> json) => OSCard(
//         id: json['id'],
//         title: json['title'],
//         identityLaw: json['identityLaw'],
//         why: json['why'],
//         daily: json['daily'],
//         weekly: json['weekly'],
//         excuse: json['excuse'],
//         rebuttal: json['rebuttal'],
//         mantra: json['mantra'],
//       );
// }

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

class MindChangeCard {
  final String id;
  final String dont;
  final String say;
  final String aim;

  MindChangeCard({
    required this.id,
    required this.dont,
    required this.say,
    required this.aim,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'dont': dont,
        'say': say,
        'aim': aim,
      };

  factory MindChangeCard.fromJson(Map<String, dynamic> json) => MindChangeCard(
        id: json['id'],
        dont: json['dont'],
        say: json['say'],
        aim: json['aim'],
      );
}