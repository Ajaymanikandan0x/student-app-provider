class Model {
  final String? name;
  final String? batch;
  final String? profileImg;
  final int? age;
  final int? id;
  final int? studentId;
  Model(
      {this.id,
      this.batch,
      this.age,
      this.name,
      this.profileImg,
      this.studentId});

  factory Model.fromMap(Map<String, dynamic> map) => Model(
      id: map['id'] ?? 0,
      name: map['name'],
      age: map['age'],
      studentId: map['student_id'],
      batch: map['batch'],
      profileImg: map['picture']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'age': age,
        'student_id': studentId,
        'batch': batch,
        'picture': profileImg,
      };
}
