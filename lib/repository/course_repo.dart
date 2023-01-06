import 'package:batch_student_starter/data_source/local_data_source/course_data_source.dart';
import 'package:batch_student_starter/model/course.dart';

abstract class CourseRepository {
  Future<int> addCourse(Course course);
  Future<List<Course>> getAllCourses();
}

class CourseRepositoryImpl extends CourseRepository {
  @override
  Future<int> addCourse(Course course) {
    return CourseDataSource().addCourse(course);
  }

  @override
  Future<List<Course>> getAllCourses() {
    return CourseDataSource().getAllCoures();
  }
}
