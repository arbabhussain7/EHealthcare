class Patient {
  final int id;
  final String name;
  final String username;
  final String phone;
  final String email;
  final bool termsAccepted;
  final String createdAt;
  final String updatedAt;

  Patient({
    this.id = 0,
    this.name = "",
    this.username = "",
    this.phone = "",
    this.email = "",
    this.termsAccepted = false,
    this.createdAt = "",
    this.updatedAt = "",
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      termsAccepted:
          json['terms_accepted'] == '1' || json['terms_accepted'] == 'true',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
