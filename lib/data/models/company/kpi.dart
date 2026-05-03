/// A single named KPI used across dashboards.
class Kpi {
  const Kpi({
    required this.id,
    required this.label,
    required this.value,
    required this.unit,
    this.delta = 0,
    this.history = const [],
  });

  final String id;
  final String label;
  final double value;
  final String unit; // "$", "%", "u", ""
  final double delta;
  final List<double> history;

  Kpi copyWith({
    String? label,
    double? value,
    String? unit,
    double? delta,
    List<double>? history,
  }) =>
      Kpi(
        id: id,
        label: label ?? this.label,
        value: value ?? this.value,
        unit: unit ?? this.unit,
        delta: delta ?? this.delta,
        history: history ?? this.history,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'value': value,
        'unit': unit,
        'delta': delta,
        'history': history,
      };

  static Kpi fromJson(Map<String, dynamic> json) => Kpi(
        id: json['id'] as String,
        label: json['label'] as String,
        value: (json['value'] as num).toDouble(),
        unit: json['unit'] as String,
        delta: (json['delta'] as num?)?.toDouble() ?? 0,
        history: (json['history'] as List<dynamic>?)
                ?.map((e) => (e as num).toDouble())
                .toList() ??
            const [],
      );
}
