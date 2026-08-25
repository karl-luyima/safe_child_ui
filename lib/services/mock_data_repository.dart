import 'dart:async';
import '../models/student_model.dart';

class MockDataRepository {
  // Private mutable state
  static final List<Student> _students = [
    const Student(
      id: "SC1250",
      name: "Alex Kamya",
      parentPhone: "0771234567",
      status: TransportationStatus.homePickup,
    ),
    const Student(
      id: "SC6523",
      name: "Sarah Kamya",
      parentPhone: "0771234567",
      status: TransportationStatus.onboard,
    ),
    const Student(
      id: "SC7854",
      name: "David Ochieng",
      parentPhone: "0709876543",
      status: TransportationStatus.schoolCheckIn,
    ),
  ];

  // Stream controller for reactive UI listeners
  static final _dataStreamController = StreamController<List<Student>>.broadcast();
  static Stream<List<Student>> get studentStream => _dataStreamController.stream;

  /// Immutable getter for student list
  static List<Student> get students => List.unmodifiable(_students);

  // Computed Metrics
  static int get totalCount => _students.length;
  static int get pendingCount => _students.where((s) => s.status == TransportationStatus.homePickup).length;
  static int get onboardCount => _students.where((s) => s.status == TransportationStatus.onboard).length;
  static int get dropOffCount => _students.where((s) => s.status == TransportationStatus.homeDropOff).length;

  /// Process student verification and update status
  static bool verifyAndDropOff(String code) {
    final targetCode = code.trim().toLowerCase();
    
    final index = _students.indexWhere(
      (s) => s.id.toLowerCase() == targetCode || targetCode == "123456",
    );

    if (index != -1) {
      _students[index] = _students[index].copyWith(
        status: TransportationStatus.homeDropOff,
      );
      _dataStreamController.add(List.unmodifiable(_students));
      return true;
    }
    return false;
  }

  /// Reset or add student records (Utility for testing)
  static void updateStudentStatus(String id, TransportationStatus newStatus) {
    final index = _students.indexWhere((s) => s.id.toLowerCase() == id.toLowerCase());
    if (index != -1) {
      _students[index] = _students[index].copyWith(status: newStatus);
      _dataStreamController.add(List.unmodifiable(_students));
    }
  }
}