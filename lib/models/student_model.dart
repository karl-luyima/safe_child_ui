class Student {
  final String id;
  final String name;
  final String parentPhone;
  final String currentStatus; // e.g., 'Home Pickup', 'School Check In'

  Student({
    required this.id,
    required this.name,
    required this.parentPhone,
    required this.currentStatus,
  });
}