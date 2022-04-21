class Person {
  String id;
  String name;
  DateTime dob;

  Person(this.id, this.name, this.dob);

  static Person create() {
    return Person('', '', DateTime.now());
  }

  static Person fromJson(Map<String, dynamic> map) {
    return Person(map['_id'], map['name'],
        DateTime.tryParse(map['birthDate']) ?? DateTime.now());
  }

  Map<String, dynamic> toJson() => {'name': name, 'birthDate': dob.toString()};

  static List<Person> toList(List<dynamic> list) {
    return list.map((element) => fromJson(element)).toList();
  }
}
