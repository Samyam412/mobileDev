import 'package:batch_student_starter/model/student.dart';
import 'package:batch_student_starter/repository/course_repo.dart';
import 'package:batch_student_starter/repository/student_repo.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../data_source/local_data_source/batch_data_source.dart';
import '../model/batch.dart';
import '../model/course.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<Batch> _lstBatches = [];
  var _dropDownValue;
  List<Course> _lstCourseSelected = [];

  final _key = GlobalKey<FormState>();
  final _fnameController = TextEditingController(text: 'Samyam');
  final _lnameController = TextEditingController(text: 'katwal');
  final _usernameController = TextEditingController(text: 'samyam');
  final _passwordController = TextEditingController(text: 'samyam123');

  @override
  void initState() {
    getBatches();
    super.initState();
  }

  getBatches() async {
    _lstBatches = await BatchDataSource().getBatch();
  }

  _showMessage(int status) {
    if (status > 0) {
      MotionToast.success(
        description: const Text('Student added'),
      ).show(context);
    } else {
      MotionToast.error(description: const Text('Error in adding student'))
          .show(context);
    }
  }

  _saveStudent() async {
    Student student = Student(
      _fnameController.text,
      _lnameController.text,
      _usernameController.text,
      _passwordController.text,
    );

    final batch = _lstBatches
        .firstWhere((element) => element.batchName == _dropDownValue);

    student.batch.target = batch;

    for (Course c in _lstCourseSelected) {
      student.course.add(c);
    }
    int status = await StudentRepositoryImpl().addStudent(student);
    _showMessage(status);
  }

  _showStudentCourse() async {
    List<Student> lstStudent = await StudentRepositoryImpl().getStudent();
    for (Student s in lstStudent) {
      debugPrint(s.fname);
      for (Course c in s.course) {
        debugPrint(c.courseName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: _fnameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    }),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _lnameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    }),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FutureBuilder(
                    future: BatchDataSource().getBatch(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return DropdownButtonFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select batch';
                            }
                            return null;
                          },
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Select Batch',
                          ),
                          items: snapshot.data!
                              .map((batch) => DropdownMenuItem(
                                    value: batch.batchName,
                                    child: Text(batch.batchName),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            _dropDownValue = value!;
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FutureBuilder(
                      future: CourseRepositoryImpl().getAllCourses(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return MultiSelectDialogField(
                            title: const Text('Select Course'),
                            items: snapshot.data!
                                .map((course) =>
                                    MultiSelectItem(course, course.courseName))
                                .toList(),
                            listType: MultiSelectListType.CHIP,
                            buttonText: const Text('Select course'),
                            buttonIcon: const Icon(Icons.search),
                            onConfirm: (values) {
                              _lstCourseSelected = values;
                            },
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select course';
                              }
                              return null;
                            }),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    }),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    }),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          _saveStudent();
                          _showStudentCourse();
                        }
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Brand Bold",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
