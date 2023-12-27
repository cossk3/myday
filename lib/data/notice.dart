class Notice {
  int? id;
  final int dId;
  final int dayType;
  final int? notiType;
  final int date;
  final int use;

  Notice({
    this.id,
    required this.dId,
    required this.dayType,
    this.notiType,
    required this.date,
    required this.use,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'd_id': dId,
      'day_type': dayType,
      'noti_type': notiType,
      'date': date,
      'use': use,
    };
  }
}