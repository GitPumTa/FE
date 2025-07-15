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

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      currentMembers: json['currentMembers'] ?? 0,
      maxMembers: json['maxMembers'] ?? 0,
      rules: List<String>.from(json['rules'] ?? []),
      password: json['password'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'currentMembers': currentMembers,
      'maxMembers': maxMembers,
      'rules': rules,
      'password': password,
      'isActive': isActive,
    };
  }


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