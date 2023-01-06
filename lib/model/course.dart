import 'package:batch_student_starter/model/student.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Course {
  @Id(assignable: true)
  int courseId;
  String courseName;

  @Backlink()
  final student = ToMany<Student>();

  Course(this.courseName, {this.courseId = 0});
}
