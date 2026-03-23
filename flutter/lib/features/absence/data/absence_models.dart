import 'package:intl/intl.dart';

class Absence {
  final int? ID;
  final DateTime TimeFrom;
  final DateTime TimeTo;
  final int TypeOfAbsence;
  
  Absence({
    this.ID,
    required this.TimeFrom,
    required this.TimeTo,
    required this.TypeOfAbsence,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      ID: json['id'] as int?,
      TimeFrom: DateTime.parse(json['time_from'] as String),
      TimeTo: DateTime.parse(json['time_to'] as String),
      TypeOfAbsence: json['type_of_absence'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': ID ?? null,
    'time_from': TimeFrom.toIso8601String(),
    'time_to': TimeTo.toIso8601String(),
    'type_of_absence': TypeOfAbsence,
  };

  String _formatTime(DateTime date) {
    //final msk = dateDt.timeZoneName; 
    final dateDt = date.toLocal();
    final day = DateFormat('dd').format(dateDt);
    final month = _getMonth(dateDt.month);
    final year = DateFormat('yyyy').format(dateDt);
    final hour = DateFormat('HH').format(dateDt);
    final minute = DateFormat('mm').format(dateDt);
    return '$day $month $year $hour:$minute ';
  }

  String get timeFromFormatted => _formatTime(TimeFrom);
  String get timeToFormatted => _formatTime(TimeTo);

  static String _getMonth(int month) {
    const months = [
      '', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return months[month];
  }

  static const Map<int, String> _absenceNames = {
    703: 'Встреча',
    704: 'По состоянию здоровья',
    705: 'По поручению руководителя',
    1032: 'Другое',
    1511: 'Удаленная работа',
    2332: 'Забытый пропуск',
  };
  
  String get typeOfAbsenceName => _absenceNames[TypeOfAbsence] ?? 'Unknown';

  @override
  String toString() => 
      'Absence(id: $ID, timeFrom: $TimeFrom, TimeTo: $TimeTo, TypeOfAbsence: $TypeOfAbsence )';
}

