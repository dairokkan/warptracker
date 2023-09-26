class Warp {
  final String name;
  final int rankType;
  final int id;
  final String time;
  final String itemType;

  const Warp ({
    this.name='',
    this.rankType=0,
    this.id=0,
    this.time='',
    this.itemType='',
  });

  factory Warp.fromJson(Map<dynamic, dynamic> json) {
    return Warp(
      id: int.parse(json['id']),
      rankType: int.parse(json['rank_type']),
      name: json['name'],
      time: json['time'],
      itemType: json['item_type'],
    );
  }
}