class Warp {
  final String name;
  final int rankType;
  final int id;
  final String time;

  const Warp ({
    this.name='',
    this.rankType=0,
    this.id=0,
    this.time='',
  });

  factory Warp.fromJson(Map<String, dynamic> json) {
    return Warp(
      id: int.parse(json['id']),
      rankType: int.parse(json['rank_type']),
      name: json['name'],
      time: json['time']
    );
  }
}