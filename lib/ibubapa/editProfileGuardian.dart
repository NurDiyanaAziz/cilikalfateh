import 'dart:async';

import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

import 'dart:convert';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import '../env.sample.dart';

class EditProfileGuardianScreen extends StatefulWidget {
  //const HomeScreen({super.key});
  var myObject = '';
  EditProfileGuardianScreen({required this.myObject});

  @override
  State<EditProfileGuardianScreen> createState() =>
      _EditProfileGuardianScreen();
}

class _EditProfileGuardianScreen extends State<EditProfileGuardianScreen> {
  late String tempProfileImage;
  late SharedPreferences logindata;

  late String errormsg;
  late bool error, showprogress;
  late String uid;
  late String fullname;
  final _formKey = GlobalKey<FormBuilderState>();
  void _onChanged(dynamic val) => debugPrint(val.toString());
  bool _emailHasError = false;
  bool _nameHasError = false;
  bool _icHasError = false;
  bool _phoneHasError = false;
  bool _firstHasError = false;
  bool _secondHasError = false;
  bool _cityHasError = false;
  bool _postHasError = false;
  bool _stateHasError = false;

  bool autoValidate = false;
  bool readOnly = false;
  bool showSegmentedControl = true;

  String index = '';

  //textEditingController
  final TextEditingController email = TextEditingController();
  final TextEditingController noTel = TextEditingController();
  final TextEditingController firstAdd = TextEditingController();
  final TextEditingController secondAdd = TextEditingController();
  final TextEditingController cityAdd = TextEditingController();
  final TextEditingController postcodeAdd = TextEditingController();
  final TextEditingController stateAdd = TextEditingController();
  final TextEditingController nameCom = TextEditingController();
  final TextEditingController phoneCom = TextEditingController();
  final TextEditingController incomeCom = TextEditingController();
  final TextEditingController firstCom = TextEditingController();
  final TextEditingController secondCom = TextEditingController();
  final TextEditingController cityCom = TextEditingController();
  final TextEditingController postcodeCom = TextEditingController();
  final TextEditingController stateCom = TextEditingController();

  @override
  void initState() {
    tempProfileImage = '';

    uid = '';
    fullname = '';

    fetchUser();
    // TODO: implement initState
    super.initState();
  }

  void fetchUser() {
    // do something

    setState(() {
      index = widget.myObject.toString();
    });
  }

  Future getData() async {
    //final response = await http.get("${Env.URL_PREFIX}/list.php");
    var url = Uri.parse('${Env.URL_PREFIX}/parentprofile.php');
    var response = await http.post(url, body: {
      'id': index, //get the username text
    });
    final items = json.decode(response.body).cast<Map<String, dynamic>>();

    return json.decode(response.body);
  }

  Future getAddress(String id) async {
    var url = Uri.parse('${Env.URL_PREFIX}/getAddress.php');
    var response = await http.post(url, body: {
      'id': id, //get the username text
    });
    final items = json.decode(response.body).cast<Map<String, dynamic>>();

    return json.decode(response.body);
  }

  Future getOccupation(String id) async {
    var url = Uri.parse('${Env.URL_PREFIX}/getOccupation.php');
    var response = await http.post(url, body: {
      'id': id, //get the username text
    });
    final items = json.decode(response.body).cast<Map<String, dynamic>>();

    return json.decode(response.body);
  }

  TabBar get _tabBar => TabBar(
        splashBorderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        unselectedLabelColor: Color.fromARGB(255, 184, 183, 183),
        tabs: [
          Text(
            "MAKLUMAT DIRI",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            "ALAMAT RUMAH",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            "PEKERJAAN",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      );

  List<String> listState = [
    "JOHOR",
    "KEDAH",
    "KELANTAN",
    "MELAKA",
    "NEGERI SEMBILAN",
    "PAHANG",
    "PULAU PINANG",
    "PERAK",
    "PERLIS",
    "SELANGOR",
    "TERENGGANU",
    "SARAWAK",
    "WILAYAH PERSEKUTUAN KUALA LUMPUR",
    "WILAYAH PERSEKUTUAN LABUAN",
    "WILAYAH PERSEKUTUAN PUTRAJAYA",
  ];

  @override
  Widget build(BuildContext context) {
    //In logical pixels
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var padding = MediaQuery.of(context).padding;
    var safeHeight = height - padding.top - padding.bottom;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: null,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          // actionsIconTheme: IconThemeData(color: Colors.white),
          //automaticallyImplyLeading: false, //disable back button

          backgroundColor: Color.fromARGB(0, 46, 41, 41),
          elevation: 0,
        ),
        // backgroundColor: Colors.transparent,
        body: Container(
          height: safeHeight,
          child: LoaderOverlay(
            reverseDuration: const Duration(milliseconds: 250),
            duration: Duration(milliseconds: 250),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                      child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: safeHeight - 150,
                                child: FutureBuilder(
                                  key: _formKey,
                                  future: getData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError)
                                      print(snapshot.error);
                                    return snapshot.hasData
                                        ? ListView.builder(
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              var list = snapshot.data[index];
                                              return Column(
                                                children: [
                                                  SizedBox(
                                                    height: 150,
                                                    child: ProfilePicture(
                                                      name: list['name'],
                                                      radius: 50,
                                                      fontsize: 21,
                                                    ),
                                                  ),
                                                  //
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 216, 215, 215),
                                                        border: Border.all(
                                                          color: Color.fromARGB(
                                                              255,
                                                              165,
                                                              165,
                                                              165),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    height: safeHeight / 2,
                                                    child: DefaultTabController(
                                                        length: 3,
                                                        child: Scaffold(
                                                          appBar: PreferredSize(
                                                            preferredSize: _tabBar
                                                                .preferredSize,
                                                            child: Material(
                                                              color: Color.fromARGB(
                                                                  255,
                                                                  224,
                                                                  113,
                                                                  49), //<-- SEE HERE
                                                              child: _tabBar,
                                                            ),
                                                          ),
                                                          body: TabBarView(
                                                            children: [
                                                              Container(
                                                                height: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            15,
                                                                        vertical:
                                                                            10),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    FormBuilder(
                                                                        autovalidateMode:
                                                                            AutovalidateMode
                                                                                .onUserInteraction,

                                                                        // enabled: false,
                                                                        onChanged:
                                                                            () {
                                                                          _formKey
                                                                              .currentState!
                                                                              .save();
                                                                          debugPrint(_formKey
                                                                              .currentState!
                                                                              .value
                                                                              .toString());
                                                                        },
                                                                        skipDisabled:
                                                                            true,
                                                                        child: Column(
                                                                            children: <Widget>[
                                                                              const SizedBox(height: 15),
                                                                              FormBuilderTextField(
                                                                                readOnly: true,
                                                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                name: 'name',
                                                                                initialValue: list['name'],
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'NAMA PENUH',
                                                                                  suffixIcon: _nameHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                ),
                                                                                onChanged: (val) {
                                                                                  setState(() {
                                                                                    _nameHasError = !(_formKey.currentState?.fields['name']?.validate() ?? false);
                                                                                  });
                                                                                },
                                                                                // valueTransformer: (text) => num.tryParse(text),
                                                                                validator: FormBuilderValidators.compose([
                                                                                  FormBuilderValidators.required(),
                                                                                  FormBuilderValidators.max(70),
                                                                                ]),

                                                                                // initialValue: '12',
                                                                                keyboardType: TextInputType.name,
                                                                                textInputAction: TextInputAction.next,
                                                                              ),
                                                                              FormBuilderTextField(
                                                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                readOnly: true,
                                                                                name: 'ic',
                                                                                initialValue: list['noIC'],
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'KAD PENGENALAN',
                                                                                  suffixIcon: _icHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                ),
                                                                                onChanged: (val) {
                                                                                  setState(() {
                                                                                    _icHasError = !(_formKey.currentState?.fields['ic']?.validate() ?? false);
                                                                                  });
                                                                                },
                                                                                // valueTransformer: (text) => num.tryParse(text),
                                                                                validator: FormBuilderValidators.compose([
                                                                                  FormBuilderValidators.required(),
                                                                                  FormBuilderValidators.numeric(),
                                                                                ]),
                                                                                // initialValue: '12',
                                                                                keyboardType: TextInputType.name,
                                                                                textInputAction: TextInputAction.next,
                                                                              ),
                                                                              FormBuilderTextField(
                                                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                name: 'email',
                                                                                initialValue: list['email'],
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'Email',
                                                                                  suffixIcon: _emailHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                ),
                                                                                onChanged: (val) {
                                                                                  setState(() {
                                                                                    _emailHasError = !(_formKey.currentState?.fields['age']?.validate() ?? false);
                                                                                  });
                                                                                },
                                                                                // valueTransformer: (text) => num.tryParse(text),
                                                                                validator: FormBuilderValidators.compose([
                                                                                  FormBuilderValidators.required(),
                                                                                  FormBuilderValidators.email(),
                                                                                ]),
                                                                                // initialValue: '12',
                                                                                keyboardType: TextInputType.emailAddress,
                                                                                textInputAction: TextInputAction.next,
                                                                              ),
                                                                              FormBuilderTextField(
                                                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                name: 'phone',
                                                                                initialValue: list['noTel'],
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'Nombor Telefon',
                                                                                  suffixIcon: _phoneHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                ),
                                                                                onChanged: (val) {
                                                                                  setState(() {
                                                                                    _phoneHasError = !(_formKey.currentState?.fields['phone']?.validate() ?? false);
                                                                                  });
                                                                                },
                                                                                // valueTransformer: (text) => num.tryParse(text),
                                                                                validator: FormBuilderValidators.compose([
                                                                                  FormBuilderValidators.required(),
                                                                                  FormBuilderValidators.numeric(),
                                                                                ]),
                                                                                // initialValue: '12',
                                                                                keyboardType: TextInputType.phone,
                                                                                textInputAction: TextInputAction.next,
                                                                              ),
                                                                            ])),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child:
                                                                    SingleChildScrollView(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                                  physics:
                                                                      AlwaysScrollableScrollPhysics(),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      //
                                                                      SizedBox(
                                                                        height:
                                                                            safeHeight,
                                                                        child:
                                                                            FutureBuilder(
                                                                          future:
                                                                              getAddress(list['addressID']),
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            if (snapshot.hasError)
                                                                              print(snapshot.error);
                                                                            return snapshot.hasData
                                                                                ? ListView.builder(
                                                                                    physics: NeverScrollableScrollPhysics(),
                                                                                    itemCount: snapshot.data.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      var list2 = snapshot.data[index];
                                                                                      return Container(
                                                                                        child: Column(
                                                                                          children: [
                                                                                            FormBuilderTextField(
                                                                                              initialValue: list2['first'],
                                                                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                              name: 'address1',
                                                                                              decoration: InputDecoration(
                                                                                                labelText: 'Alamat 1',
                                                                                                suffixIcon: _firstHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                              ),
                                                                                              onChanged: (val) {
                                                                                                setState(() {
                                                                                                  _firstHasError = !(_formKey.currentState?.fields['address1']?.validate() ?? false);
                                                                                                });
                                                                                              },
                                                                                              // valueTransformer: (text) => num.tryParse(text),
                                                                                              validator: FormBuilderValidators.compose([
                                                                                                FormBuilderValidators.required(),
                                                                                              ]),
                                                                                              // initialValue: '12',
                                                                                              keyboardType: TextInputType.text,
                                                                                              textInputAction: TextInputAction.next,
                                                                                            ),
                                                                                            FormBuilderTextField(
                                                                                              initialValue: list2['second'],
                                                                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                              name: 'address2',
                                                                                              decoration: InputDecoration(
                                                                                                labelText: 'Alamat 2',
                                                                                                suffixIcon: _secondHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                              ),
                                                                                              onChanged: (val) {
                                                                                                setState(() {
                                                                                                  _secondHasError = !(_formKey.currentState?.fields['address2']?.validate() ?? false);
                                                                                                });
                                                                                              },
                                                                                              // valueTransformer: (text) => num.tryParse(text),
                                                                                              validator: FormBuilderValidators.compose([
                                                                                                FormBuilderValidators.required(),
                                                                                              ]),
                                                                                              // initialValue: '12',
                                                                                              keyboardType: TextInputType.text,
                                                                                              textInputAction: TextInputAction.next,
                                                                                            ),
                                                                                            FormBuilderTextField(
                                                                                              initialValue: list2['city'],
                                                                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                              name: 'city',
                                                                                              decoration: InputDecoration(
                                                                                                labelText: 'Bandar',
                                                                                                suffixIcon: _cityHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                              ),
                                                                                              onChanged: (val) {
                                                                                                setState(() {
                                                                                                  _cityHasError = !(_formKey.currentState?.fields['city']?.validate() ?? false);
                                                                                                });
                                                                                              },
                                                                                              // valueTransformer: (text) => num.tryParse(text),
                                                                                              validator: FormBuilderValidators.compose([
                                                                                                FormBuilderValidators.required(),
                                                                                              ]),
                                                                                              // initialValue: '12',
                                                                                              keyboardType: TextInputType.text,
                                                                                              textInputAction: TextInputAction.next,
                                                                                            ),
                                                                                            FormBuilderTextField(
                                                                                              initialValue: list2['postcode'],
                                                                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                              name: 'postcode',
                                                                                              decoration: InputDecoration(
                                                                                                labelText: 'Poskod',
                                                                                                suffixIcon: _postHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                              ),
                                                                                              onChanged: (val) {
                                                                                                setState(() {
                                                                                                  _postHasError = !(_formKey.currentState?.fields['postcode']?.validate() ?? false);
                                                                                                });
                                                                                              },
                                                                                              // valueTransformer: (text) => num.tryParse(text),
                                                                                              validator: FormBuilderValidators.compose([
                                                                                                FormBuilderValidators.required(),
                                                                                                FormBuilderValidators.numeric(),
                                                                                                FormBuilderValidators.max(99999),
                                                                                              ]),
                                                                                              // initialValue: '12',
                                                                                              keyboardType: TextInputType.streetAddress,
                                                                                              textInputAction: TextInputAction.next,
                                                                                            ),
                                                                                            FormBuilderTextField(
                                                                                              initialValue: list2['state'],
                                                                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                              name: 'state',
                                                                                              decoration: InputDecoration(
                                                                                                labelText: 'Negeri',
                                                                                                suffixIcon: _stateHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                              ),
                                                                                              onChanged: (val) {
                                                                                                setState(() {
                                                                                                  _stateHasError = !(_formKey.currentState?.fields['state']?.validate() ?? false);
                                                                                                });
                                                                                              },
                                                                                              // valueTransformer: (text) => num.tryParse(text),
                                                                                              validator: FormBuilderValidators.compose([
                                                                                                FormBuilderValidators.required(),
                                                                                              ]),
                                                                                              // initialValue: '12',
                                                                                              keyboardType: TextInputType.streetAddress,
                                                                                              textInputAction: TextInputAction.next,
                                                                                            ),
                                                                                            FormBuilderDropdown(
                                                                                              name: 'states',
                                                                                              decoration: InputDecoration(
                                                                                                labelText: list['state'] ?? 'PILIH NEGERI',
                                                                                              ),
                                                                                              validator: FormBuilderValidators.compose([
                                                                                                FormBuilderValidators.required()
                                                                                              ]),
                                                                                              onChanged: (value) {},
                                                                                              items: listState
                                                                                                  .map((states) => DropdownMenuItem(
                                                                                                        value: states,
                                                                                                        child: Text('$states'),
                                                                                                      ))
                                                                                                  .toList(),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    })
                                                                                : CircularProgressIndicator();
                                                                          },
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height:
                                                                    safeHeight,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      //
                                                                      SizedBox(
                                                                        height: safeHeight -
                                                                            100,
                                                                        child:
                                                                            FutureBuilder(
                                                                          future:
                                                                              getOccupation(list['occupationID']),
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            if (snapshot.hasError)
                                                                              print(snapshot.error);
                                                                            return snapshot.hasData
                                                                                ? ListView.builder(
                                                                                    physics: AlwaysScrollableScrollPhysics(),
                                                                                    itemCount: snapshot.data.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      var list2 = snapshot.data[index];
                                                                                      return Container(
                                                                                          child: Column(children: [
                                                                                        FormBuilderTextField(
                                                                                          initialValue: list2['name'],
                                                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                          name: 'nameOcc',
                                                                                          decoration: InputDecoration(
                                                                                            labelText: 'Nama Pekerjaan',
                                                                                            suffixIcon: _firstHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                          ),
                                                                                          onChanged: (val) {
                                                                                            setState(() {
                                                                                              _firstHasError = !(_formKey.currentState?.fields['address1']?.validate() ?? false);
                                                                                            });
                                                                                          },
                                                                                          // valueTransformer: (text) => num.tryParse(text),
                                                                                          validator: FormBuilderValidators.compose([
                                                                                            FormBuilderValidators.required(),
                                                                                          ]),
                                                                                          // initialValue: '12',
                                                                                          keyboardType: TextInputType.text,
                                                                                          textInputAction: TextInputAction.next,
                                                                                        ),
                                                                                        FormBuilderTextField(
                                                                                          initialValue: list2['company'],
                                                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                          name: 'address2',
                                                                                          decoration: InputDecoration(
                                                                                            labelText: 'Nama Majikan',
                                                                                            suffixIcon: _secondHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                          ),
                                                                                          onChanged: (val) {
                                                                                            setState(() {
                                                                                              _secondHasError = !(_formKey.currentState?.fields['address2']?.validate() ?? false);
                                                                                            });
                                                                                          },
                                                                                          // valueTransformer: (text) => num.tryParse(text),
                                                                                          validator: FormBuilderValidators.compose([
                                                                                            FormBuilderValidators.required(),
                                                                                          ]),
                                                                                          // initialValue: '12',
                                                                                          keyboardType: TextInputType.text,
                                                                                          textInputAction: TextInputAction.next,
                                                                                        ),
                                                                                        FormBuilderTextField(
                                                                                          initialValue: list2['noTel'],
                                                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                          name: 'city',
                                                                                          decoration: InputDecoration(
                                                                                            labelText: 'No. Telefon Majikan',
                                                                                            suffixIcon: _cityHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                          ),
                                                                                          onChanged: (val) {
                                                                                            setState(() {
                                                                                              _cityHasError = !(_formKey.currentState?.fields['city']?.validate() ?? false);
                                                                                            });
                                                                                          },
                                                                                          // valueTransformer: (text) => num.tryParse(text),
                                                                                          validator: FormBuilderValidators.compose([
                                                                                            FormBuilderValidators.required(),
                                                                                          ]),
                                                                                          // initialValue: '12',
                                                                                          keyboardType: TextInputType.text,
                                                                                          textInputAction: TextInputAction.next,
                                                                                        ),
                                                                                        FormBuilderTextField(
                                                                                          initialValue: list2['income'],
                                                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                          name: 'income',
                                                                                          decoration: InputDecoration(
                                                                                            labelText: 'Gaji',
                                                                                            suffixIcon: _postHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                          ),
                                                                                          onChanged: (val) {
                                                                                            setState(() {
                                                                                              _postHasError = !(_formKey.currentState?.fields['income']?.validate() ?? false);
                                                                                            });
                                                                                          },
                                                                                          // valueTransformer: (text) => num.tryParse(text),
                                                                                          validator: FormBuilderValidators.compose([
                                                                                            FormBuilderValidators.required(),
                                                                                            FormBuilderValidators.numeric(),
                                                                                            FormBuilderValidators.max(99999),
                                                                                          ]),
                                                                                          // initialValue: '12',
                                                                                          keyboardType: TextInputType.text,
                                                                                          textInputAction: TextInputAction.next,
                                                                                        ),
                                                                                        Container(
                                                                                          height: safeHeight,
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: <Widget>[
                                                                                              //
                                                                                              SizedBox(
                                                                                                height: safeHeight,
                                                                                                child: FutureBuilder(
                                                                                                  future: getAddress(list2['addressID']),
                                                                                                  builder: (context, snapshot) {
                                                                                                    if (snapshot.hasError) print(snapshot.error);
                                                                                                    return snapshot.hasData
                                                                                                        ? ListView.builder(
                                                                                                            physics: NeverScrollableScrollPhysics(),
                                                                                                            itemCount: snapshot.data.length,
                                                                                                            itemBuilder: (context, index) {
                                                                                                              var list2 = snapshot.data[index];
                                                                                                              return Container(
                                                                                                                child: Column(
                                                                                                                  children: [
                                                                                                                    FormBuilderTextField(
                                                                                                                      initialValue: list2['first'],
                                                                                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                                                      name: 'address1',
                                                                                                                      decoration: InputDecoration(
                                                                                                                        labelText: 'Alamat 1',
                                                                                                                        suffixIcon: _firstHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                                                      ),
                                                                                                                      onChanged: (val) {
                                                                                                                        setState(() {
                                                                                                                          _firstHasError = !(_formKey.currentState?.fields['address1']?.validate() ?? false);
                                                                                                                        });
                                                                                                                      },
                                                                                                                      // valueTransformer: (text) => num.tryParse(text),
                                                                                                                      validator: FormBuilderValidators.compose([
                                                                                                                        FormBuilderValidators.required(),
                                                                                                                      ]),
                                                                                                                      // initialValue: '12',
                                                                                                                      keyboardType: TextInputType.text,
                                                                                                                      textInputAction: TextInputAction.next,
                                                                                                                    ),
                                                                                                                    FormBuilderTextField(
                                                                                                                      initialValue: list2['second'],
                                                                                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                                                      name: 'address2',
                                                                                                                      decoration: InputDecoration(
                                                                                                                        labelText: 'Alamat 2',
                                                                                                                        suffixIcon: _secondHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                                                      ),
                                                                                                                      onChanged: (val) {
                                                                                                                        setState(() {
                                                                                                                          _secondHasError = !(_formKey.currentState?.fields['address2']?.validate() ?? false);
                                                                                                                        });
                                                                                                                      },
                                                                                                                      // valueTransformer: (text) => num.tryParse(text),
                                                                                                                      validator: FormBuilderValidators.compose([
                                                                                                                        FormBuilderValidators.required(),
                                                                                                                      ]),
                                                                                                                      // initialValue: '12',
                                                                                                                      keyboardType: TextInputType.text,
                                                                                                                      textInputAction: TextInputAction.next,
                                                                                                                    ),
                                                                                                                    FormBuilderTextField(
                                                                                                                      initialValue: list2['city'],
                                                                                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                                                      name: 'city',
                                                                                                                      decoration: InputDecoration(
                                                                                                                        labelText: 'Bandar',
                                                                                                                        suffixIcon: _cityHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                                                      ),
                                                                                                                      onChanged: (val) {
                                                                                                                        setState(() {
                                                                                                                          _cityHasError = !(_formKey.currentState?.fields['city']?.validate() ?? false);
                                                                                                                        });
                                                                                                                      },
                                                                                                                      // valueTransformer: (text) => num.tryParse(text),
                                                                                                                      validator: FormBuilderValidators.compose([
                                                                                                                        FormBuilderValidators.required(),
                                                                                                                      ]),
                                                                                                                      // initialValue: '12',
                                                                                                                      keyboardType: TextInputType.text,
                                                                                                                      textInputAction: TextInputAction.next,
                                                                                                                    ),
                                                                                                                    FormBuilderTextField(
                                                                                                                      initialValue: list2['postcode'],
                                                                                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                                                      name: 'postcode',
                                                                                                                      decoration: InputDecoration(
                                                                                                                        labelText: 'Poskod',
                                                                                                                        suffixIcon: _postHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                                                      ),
                                                                                                                      onChanged: (val) {
                                                                                                                        setState(() {
                                                                                                                          _postHasError = !(_formKey.currentState?.fields['postcode']?.validate() ?? false);
                                                                                                                        });
                                                                                                                      },
                                                                                                                      // valueTransformer: (text) => num.tryParse(text),
                                                                                                                      validator: FormBuilderValidators.compose([
                                                                                                                        FormBuilderValidators.required(),
                                                                                                                        FormBuilderValidators.numeric(),
                                                                                                                        FormBuilderValidators.max(99999),
                                                                                                                      ]),
                                                                                                                      // initialValue: '12',
                                                                                                                      keyboardType: TextInputType.number,
                                                                                                                      textInputAction: TextInputAction.next,
                                                                                                                    ),
                                                                                                                    FormBuilderTextField(
                                                                                                                      initialValue: list2['state'],
                                                                                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                                                      name: 'state',
                                                                                                                      decoration: InputDecoration(
                                                                                                                        labelText: 'Negeri',
                                                                                                                        suffixIcon: _stateHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                                                                                                                      ),
                                                                                                                      onChanged: (val) {
                                                                                                                        setState(() {
                                                                                                                          _stateHasError = !(_formKey.currentState?.fields['state']?.validate() ?? false);
                                                                                                                          print(val);
                                                                                                                        });
                                                                                                                      },
                                                                                                                      // valueTransformer: (text) => num.tryParse(text),
                                                                                                                      validator: FormBuilderValidators.compose([
                                                                                                                        FormBuilderValidators.required(),
                                                                                                                        FormBuilderValidators.max(99999),
                                                                                                                      ]),
                                                                                                                      // initialValue: '12',
                                                                                                                      keyboardType: TextInputType.streetAddress,
                                                                                                                      textInputAction: TextInputAction.next,
                                                                                                                    ),
                                                                                                                    FormBuilderDropdown(
                                                                                                                      name: 'states',
                                                                                                                      decoration: InputDecoration(
                                                                                                                        labelText: 'Negeri',
                                                                                                                      ),
                                                                                                                      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                                                                                                                      items: listState
                                                                                                                          .map((states) => DropdownMenuItem(
                                                                                                                                value: states,
                                                                                                                                child: Text('$states'),
                                                                                                                              ))
                                                                                                                          .toList(),
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              );
                                                                                                            })
                                                                                                        : CircularProgressIndicator();
                                                                                                  },
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                      ]));
                                                                                    })
                                                                                : CircularProgressIndicator();
                                                                          },
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              );
                                            })
                                        : CircularProgressIndicator();
                                  },
                                ),
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.green),
                                  ),
                                  onPressed: () {
                                    debugPrint(_formKey
                                        .currentState?.fields['postcode']?.value
                                        .toString());
                                  },
                                  child: Text('KEMASKINI'))
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                )
              ],
            ),
          ),
        ));
  }
}
