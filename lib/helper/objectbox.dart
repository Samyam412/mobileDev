import 'dart:io';

import 'package:batch_student_starter/model/batch.dart';
import 'package:batch_student_starter/model/student.dart';
import 'package:path_provider/path_provider.dart';

import '../model/course.dart';

import '../objectbox.g.dart';

//this is a database
class ObjectBoxInstance {
  late final Store _store;
  late final Box<Batch> _batch;
  late final Box<Student> _student;
  late final Box<Course> _course;

  //constructors
  ObjectBoxInstance(this._store) {
    _batch = Box<Batch>(_store);
    _student = Box<Student>(_store);
    _course = Box<Course>(_store);

    insertBaches();
    insertCourses();
  }
//initalization of object box

  static Future<ObjectBoxInstance> init() async {
    var dir = await getApplicationDocumentsDirectory();
    final store = Store(
      //tells what entities the model has
      getObjectBoxModel(),
      directory: '${dir.path}.student_course',
    );

    return ObjectBoxInstance(store);
  }

  //delete store and all boxes
  static Future<void> deleteDatabase() async {
    var dir = await getApplicationDocumentsDirectory();
    Directory('${dir.path}/student_course').deleteSync(recursive: true);
  }

  //--------Batch Queries--------
  int addBatch(Batch batch) {
    return _batch.put(batch);
  }

  List<Batch> getAllBatch() {
    return _batch.getAll();
  }

  void insertBaches() {
    List<Batch> lstBatches = getAllBatch();
    if (lstBatches.isEmpty) {
      addBatch(Batch('29-A'));
      addBatch(Batch('29-B'));
      addBatch(Batch('28-A'));
      addBatch(Batch('28-B'));
    }
  }
  //--------Student Queries--------

  int addStudent(Student student) {
    return _student.put(student);
  }

  List<Student> getAllStudent() {
    return _student.getAll();
  }

  //--------Course Queries--------

  void insertCourses() {
    List<Course> lstCourse = getAllCourses();
    if (lstCourse.isEmpty) {
      addCourse(Course('Web-Api'));
      addCourse(Course('Flutter'));
      addCourse(Course('Django'));
      addCourse(Course('Design thinking'));
      addCourse(Course('React'));
    }
  }

  int addCourse(Course course) {
    return _course.put(course);
  }

  List<Course> getAllCourses() {
    return _course.getAll();
  }
}
