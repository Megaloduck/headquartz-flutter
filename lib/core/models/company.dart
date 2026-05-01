// lib/core/models/company.dart

class Company {
  final String name;
  final int level;
  final String description;

  const Company({
    this.name = 'My Company',
    this.level = 1,
    this.description = 'A growing enterprise',
  });

  Company copyWith({
    String? name,
    int? level,
    String? description,
  }) {
    return Company(
      name: name ?? this.name,
      level: level ?? this.level,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'level': level,
        'description': description,
      };

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        name: json['name'] as String,
        level: json['level'] as int,
        description: json['description'] as String? ?? '',
      );
}