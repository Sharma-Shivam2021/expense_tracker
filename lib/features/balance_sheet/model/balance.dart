class Balance {
  final int maxBudget;

  const Balance({
    required this.maxBudget,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Balance &&
          runtimeType == other.runtimeType &&
          maxBudget == other.maxBudget);

  @override
  int get hashCode => maxBudget.hashCode;

  @override
  String toString() {
    return 'Balance{ maxBudget: $maxBudget,}';
  }

  Balance copyWith({
    int? maxBudget,
  }) {
    return Balance(
      maxBudget: maxBudget ?? this.maxBudget,
    );
  }

  factory Balance.fromJson(Map<String, dynamic> map) {
    return Balance(
      maxBudget: map['maxBudget'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "maxBudget": maxBudget,
    };
  }
}
