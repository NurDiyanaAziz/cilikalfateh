import 'dart:ffi';

import 'package:flutter/material.dart';

class PendaftaranModel {
  int id;
  int studentID;
  int programIDAdmisiion;
  int sessionIDAdmission;
  String modeAdmission;
  String statusAcceptance;
  String statusPayment;
  final String registerDate;
  String supplies;
  double totalPayment;
  double totalPaid;
  final String createdAt;
  final String updatedAt;
  String namaPelajar;
  bool checked;

  PendaftaranModel(
      {this.id = 0,
      this.studentID = 0,
      this.programIDAdmisiion = 0,
      this.sessionIDAdmission = 0,
      this.modeAdmission = '',
      this.statusAcceptance = '',
      this.registerDate = '',
      this.statusPayment = '',
      this.supplies = '',
      this.totalPayment = 0,
      this.totalPaid = 0,
      this.createdAt = '',
      this.updatedAt = '',
      this.namaPelajar = '',
      this.checked = false});

  //add to firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'modeAdmission': modeAdmission,
      'studentID': studentID,
      'programIDAdmission': programIDAdmisiion,
      'registerDate': registerDate,
      'sessionIDAdmission': sessionIDAdmission,
      'statusPayment': statusPayment,
      'statusAcceptance': statusAcceptance,
      'supplies': supplies,
      'totalPaid': totalPaid,
      'totalPayment': totalPayment,
      'updated_at': updatedAt,
    };
  }

//generate from firebase
  factory PendaftaranModel.fromJson(Map<String, dynamic> json) {
    return PendaftaranModel(
      id: json['id'],
      createdAt: json['created_at'],
      modeAdmission: json['modeAdmission'],
      studentID: json['studentID'],
      programIDAdmisiion: json['programIDAdmission'],
      registerDate: json['registerDate'],
      sessionIDAdmission: json['sessionIDAdmission'],
      statusPayment: json['statusPayment'],
      statusAcceptance: json['statusAcceptance'],
      supplies: json['supplies'],
      totalPaid: json['totalPaid'],
      totalPayment: json['totalPayment'],
      updatedAt: json['updated_at'],
    );
  }
}
