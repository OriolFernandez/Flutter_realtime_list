class Band {
  String id;
  String name;
  int votes;

  Band({
    this.id,
    this.name,
    this.votes,
  });

  factory Band.fromMap(Map<String, dynamic> map) {
    return Band(
      id: map['id'],
      name: map['name'],
      votes: map['votes'],
    );
  }
}
