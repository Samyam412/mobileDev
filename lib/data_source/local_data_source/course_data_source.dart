import 'package:batch_student_starter/model/course.dart';
import 'package:batch_student_starter/state/objectbox_state.dart';

import '../../helper/objectbox.dart';

class CourseDataSource {
  ObjectBoxInstance get objectBoxInstance => ObjectBoxState.objectBoxInstance!;

  Future<int> addCourse(Course course) async {
    try {
      return objectBoxInstance.addCourse(course);
    } catch (e) {
      return 0;
    }
  }

  Future<List<Course>> getAllCoures() async {
    try {
      return objectBoxInstance.getAllCourses();
    } catch (e) {
      return [];
    }
  }

}
