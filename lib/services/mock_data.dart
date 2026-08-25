import '../models/student_model.dart';

class MockDataRepository {
  // Initial list of student records
  static List<Student> students = [
    Student(id: "SC1250", name: "Alex Kamya", parentPhone: "0771234567", currentStatus: "Home Pickup"),
    Student(id: "SC6523", name: "Sarah Kamya", parentPhone: "0771234567", currentStatus: "Home Pickup"),
    Student(id: "SC7854", name: "David Ochieng", parentPhone: "0709876543", currentStatus: "School Check In"),
  ];

  // Dynamic getters for dashboard numbers
  static int get onboardCount => students.where((s) => s.currentStatus != "Home Drop off").length;
  static int get dropOffCount => students.where((s) => s.currentStatus == "Home Drop off").length;

  // Process a code entered or scanned by the driver
  static bool verifyAndDropOff(String code) {
    int index = students.indexWhere((s) => s.id.toLowerCase() == code.trim().toLowerCase() || code == "123456");

    if (index != -1) {
      students[index] = Student(
        id: students[index].id,
        name: students[index].name,
        parentPhone: students[index].parentPhone,
        currentStatus: "Home Drop off",
      );
      return true;
    }
    return false;
  }
}