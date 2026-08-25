// lib/models/student_model.dart

enum TransportationStatus {
  homePickup,
  onboard,
  schoolCheckIn,
  homeDropOff,
}

class Student {
  final String id;
  final String name;
  final String parentPhone;
  final TransportationStatus status;

  const Student({
    required this.id,
    required this.name,
    required this.parentPhone,
    required this.status,
  });

  /// Copy helper to update student records reactively
  Student copyWith({
    String? id,
    String? name,
    String? parentPhone,
    TransportationStatus? status,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      parentPhone: parentPhone ?? this.parentPhone,
      status: status ?? this.status,
    );
  }
}