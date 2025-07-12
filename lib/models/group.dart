class Group {
  final String id;
  final String name;
  final String description;
  final int currentMembers;
  final int maxMembers;
  final List<String> rules;
  final String password;
  final bool isActive;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.currentMembers,
    required this.maxMembers,
    required this.rules,
    required this.password,
    this.isActive = false,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    int? currentMembers,
    int? maxMembers,
    List<String>? rules,
    String? password,
    bool? isActive,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      currentMembers: currentMembers ?? this.currentMembers,
      maxMembers: maxMembers ?? this.maxMembers,
      rules: rules ?? this.rules,
      password: password ?? this.password,
      isActive: isActive ?? this.isActive,
    );
  }

  String get memberStatus => '$currentMembers/$maxMembers명';
}