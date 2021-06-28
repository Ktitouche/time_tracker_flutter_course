import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/home/model/job.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:flutter/material.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> streamJobs();
}

class FireStoreDatabase implements Database {
  FireStoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createJob(Job job) => _setData(
        path: APIPath.job(uid, 'job_abc'),
        data: job.toMap(),
      );

  Stream<List<Job>> streamJobs() => _collectionStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final refernce = FirebaseFirestore.instance.doc(path);
    print('$path:$data');
    await refernce.set(data);
  }

  Stream<List<T>> _collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data) builder,
  }) {
    final path = APIPath.jobs(uid);
    final refernce = FirebaseFirestore.instance.collection(path);
    final snapshot = refernce.snapshots();
    return snapshot.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => builder(snapshot.data()),
        )
        .toList());
  }
}
