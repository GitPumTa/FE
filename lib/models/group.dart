class Group {
  final String id;
  final String name;
  final String description;
  final String memberStatus;
  final bool isActive;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.memberStatus,
    this.isActive = false,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? memberStatus,
    bool? isActive,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      memberStatus: memberStatus ?? this.memberStatus,
      isActive: isActive ?? this.isActive,
    );
  }
}