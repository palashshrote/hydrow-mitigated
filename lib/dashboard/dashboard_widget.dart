/*
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/flutter_flow_web_view.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:hydrow/tank_summary/tank_summary_widget.dart';
import 'dart:ui';
import 'dart:async';
*/
import 'package:hydrow/custom_code/actions/call_a_p_i.dart';
import 'package:hydrow/edit_device_pravah/edit_device_pravah_widget.dart';
import 'package:hydrow/primary_meter/primary_meter_widget.dart';

import '../components/TermsandCondition_widget.dart';
import '../primary_tank/primary_tank_widget.dart';
import '/auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/about_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/components/contact_us_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:hydrow/custom_code/actions/new_custom_action.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dashboard_model.dart';
export 'dashboard_model.dart';
import 'package:hydrow/edit_profile/edit_profile_widget.dart';
import 'package:hydrow/edit_device/edit_device_widget.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauges;

class FFAppState {
  final meterKey = GlobalKey();
  final String tankKey = 'tankKey';
}

class DashboardWidget extends StatefulWidget {
  DashboardWidget({
    Key? key,
    this.water = '0',
  }) : super(key: key);

  // Getting the default tank and giving the key to tankKey variable.
  // var meterKey = FFAppState().meterKey;
  // var tankKey = FFAppState().tankKey;
  // final meterKey;
  // final tankKey;
  final String? water;

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

int selectedindex = 0;

final appTheme = ThemeData(
  primarySwatch: Colors.red,
);

class _DashboardWidgetState extends State<DashboardWidget>
    with TickerProviderStateMixin {
  late var meterKey;
  late var tankKey;

  late DashboardModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String date = new DateFormat.yMMMMd('en_US').format(new DateTime.now());
  String dropdownValueStarr = 'Daily';
  String dropdownValuePravahRate = 'Daily';
  String dropdownValuePravahTotal = 'Daily';
  double _pointerValue = 60;
  bool isActive = true;
  bool isActivePravah = true;
  // double _waterlevel = 0.5;

  final animationsMap = {
    'columnOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    meterKey = FFAppState().meterKey;
    tankKey = FFAppState().tankKey;
    _model = createModel(context, () => DashboardModel());
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.lockOrientation();
      isActive = await functions.checkActivity(tankKey);
      isActivePravah = await functions.checkActivityPravah(meterKey);
      _model.waterLevel = await actions.callAPI(
          functions.generateChannelID(tankKey),
          functions.generateReadAPI(tankKey));
      _model.temperature = await callAPITemperature(
          functions.generateChannelID(tankKey),
          functions.generateReadAPI(tankKey));
      setState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    //Giving the Default tank key to widget tankKey
    // widget.tankKey = FFAppState().tankKey;
    List<Widget> drawers = <Widget>[
      // Starr Drawer
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          backgroundColor: Color(0xFF0C0C0C),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              // Drawer Element
              InkWell(
                onTap: () async {
                  context.pushNamed('AddDeviceQRScan');
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        CupertinoIcons.add,
                        size: 20,
                        color: Color(0xFF93DCEC),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Add Device',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrimaryTankWidget()),
                  )
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/images/change-icon.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                            Color(0xFF93DCEC), BlendMode.srcIn),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Change Defaults',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfileWidget()),
                  )
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/images/edit-icon.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                            Color(0xFF93DCEC), BlendMode.srcIn),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Edit Profile',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditDeviceWidget()),
                  )
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/images/settings-icon.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                            Color(0xFF93DCEC), BlendMode.srcIn),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Settings',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsandCondition()),
                  )
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        CupertinoIcons.doc_text,
                        size: 20,
                        color: Color(0xFF93DCEC),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Terms & Conditions',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutWidget()),
                  )
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        CupertinoIcons.info_circle,
                        size: 20,
                        color: Color(0xFF93DCEC),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('About',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactUsWidget()),
                  )
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        CupertinoIcons.ellipses_bubble,
                        size: 20,
                        color: Color(0xFF93DCEC),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Contact Us',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  GoRouter.of(context).prepareAuthEvent();
                  await signOut();

                  context.goNamedAuth('LogInSignUp', mounted);
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/images/logout-icon.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                            Color(0xFF93DCEC), BlendMode.srcIn),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Logout',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Pravah Drawer
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          backgroundColor: Color(0xFF0C0C0C),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              // Drawer Element
              InkWell(
                onTap: () async {
                  context.pushNamed('AddDeviceQRScanPravah');
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        CupertinoIcons.add,
                        size: 20,
                        color: Color(0xFF93DCEC),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Add Device',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrimaryMeterWidget()),
                  )
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/images/change-icon.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                            Color(0xFF93DCEC), BlendMode.srcIn),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Change Defaults',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfileWidget()),
                  )
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/images/edit-icon.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                            Color(0xFF93DCEC), BlendMode.srcIn),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Edit Profile',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditDevicePravahWidget()),
                  )
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/images/settings-icon.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                            Color(0xFF93DCEC), BlendMode.srcIn),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Settings',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsandCondition()),
                  )
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        CupertinoIcons.doc_text,
                        size: 20,
                        color: Color(0xFF93DCEC),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Terms & Conditions',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutWidget()),
                  )
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        CupertinoIcons.info_circle,
                        size: 20,
                        color: Color(0xFF93DCEC),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('About',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactUsWidget()),
                  )
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        CupertinoIcons.ellipses_bubble,
                        size: 20,
                        color: Color(0xFF93DCEC),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Contact Us',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  GoRouter.of(context).prepareAuthEvent();
                  await signOut();

                  context.goNamedAuth('LogInSignUp', mounted);
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/images/logout-icon.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                            Color(0xFF93DCEC), BlendMode.srcIn),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Logout',
                          style: GoogleFonts.leagueSpartan(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
    List<Widget> pages = <Widget>[
      SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 25, 20, 0),
                child: Text(
                  'Hi,',
                  style: GoogleFonts.leagueSpartan(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w600,
                      fontSize: 40),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 5, 20, 0),
                child: Text(
                  currentUserDisplayName, //replace with $username
                  style: GoogleFonts.leagueSpartan(
                      color: Color(0xFF2F9DC1),
                      fontWeight: FontWeight.w600,
                      fontSize: 40),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                child: Text(
                  '$date',
                  style: GoogleFonts.leagueSpartan(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.normal,
                      fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 20),
                child: StreamBuilder<List<TankRecord>>(
                  //Fetching the tank record of the default tank
                  stream: queryTankRecord(
                    parent: currentUserReference,
                    queryBuilder: (tankRecord) => tankRecord.where('TankKey',
                        isEqualTo: FFAppState().tankKey),
                    singleRecord: true,
                  ),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 75,
                          height: 75,
                          child: SpinKitRipple(
                            color: Color(0xFF7E8083),
                            size: 75,
                          ),
                        ),
                      );
                    }
                    List<TankRecord> containerTankRecordList = snapshot.data!;
                    // Return an empty Container when the item does not exist.
                    if (snapshot.data!.isEmpty) {
                      return Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PrimaryTankWidget()));
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Color(0xFF686868)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Default Tank is not selected. \nClick to select a Default Tank.',
                                    style: GoogleFonts.leagueSpartan(
                                      height: 1.5,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    }
                    final containerTankRecord =
                        containerTankRecordList.isNotEmpty
                            ? containerTankRecordList.first
                            : null;
                    //If data found return the Water tank container
                    return Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 30, 20, 0),
                                child: Container(
                                  height: 350,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFECECEC),
                                    shape: BoxShape.rectangle,
                                    // borderRadius: BorderRadius.circular(20),
                                    // border: Border.all(color: Color(0xFFF7F7F8)),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: WaveWidget(
                                          config: CustomConfig(colors: [
                                            Color(0xFF93DCEC),
                                            Color(0xFF91D9E9),
                                            Color(0xFF52B9D5)
                                          ], durations: [
                                            4000,
                                            6000,
                                            8000
                                          ], heightPercentages: [
                                            isActive
                                                ? 0.87 -
                                                    functions.tankAPI(
                                                        functions.calculateWaterAvailable(
                                                            containerTankRecord!
                                                                .length!,
                                                            containerTankRecord
                                                                .breadth!,
                                                            containerTankRecord
                                                                .height!,
                                                            containerTankRecord
                                                                .radius!,
                                                            _model.waterLevel,
                                                            containerTankRecord
                                                                .isCuboid!),
                                                        functions.calculateVolume(
                                                            containerTankRecord
                                                                .isCuboid!,
                                                            containerTankRecord
                                                                .length!,
                                                            containerTankRecord
                                                                .breadth!,
                                                            containerTankRecord
                                                                .height!,
                                                            containerTankRecord
                                                                .radius!))
                                                : 0.87,
                                            isActive
                                                ? 0.87 -
                                                    functions.tankAPI(
                                                        functions.calculateWaterAvailable(
                                                            containerTankRecord!
                                                                .length!,
                                                            containerTankRecord
                                                                .breadth!,
                                                            containerTankRecord
                                                                .height!,
                                                            containerTankRecord
                                                                .radius!,
                                                            _model.waterLevel,
                                                            containerTankRecord
                                                                .isCuboid!),
                                                        functions.calculateVolume(
                                                            containerTankRecord
                                                                .isCuboid!,
                                                            containerTankRecord
                                                                .length!,
                                                            containerTankRecord
                                                                .breadth!,
                                                            containerTankRecord
                                                                .height!,
                                                            containerTankRecord
                                                                .radius!))
                                                : 0.87,
                                            isActive
                                                ? 0.87 -
                                                    functions.tankAPI(
                                                        functions.calculateWaterAvailable(
                                                            containerTankRecord!
                                                                .length!,
                                                            containerTankRecord
                                                                .breadth!,
                                                            containerTankRecord
                                                                .height!,
                                                            containerTankRecord
                                                                .radius!,
                                                            _model.waterLevel,
                                                            containerTankRecord
                                                                .isCuboid!),
                                                        functions.calculateVolume(
                                                            containerTankRecord
                                                                .isCuboid!,
                                                            containerTankRecord
                                                                .length!,
                                                            containerTankRecord
                                                                .breadth!,
                                                            containerTankRecord
                                                                .height!,
                                                            containerTankRecord
                                                                .radius!))
                                                : 0.87
                                          ]
                                              // heightPercentages: [
                                              //   0.50,
                                              //   0.52,
                                              //   0.54
                                              // ], //replace with actual tank height
                                              // blur: MaskFilter.blur(BlurStyle.solid, 1),
                                              ),
                                          waveAmplitude: 3.00, //depth of curves
                                          waveFrequency:
                                              3, //number of curves in waves
                                          size: Size(
                                            double.infinity,
                                            double.infinity,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          child: Center(
                                        child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            decoration: BoxDecoration(
                                              color: Color(0xC00C0C0C),
                                              shape: BoxShape.circle,
                                            ),
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    50, 0, 50, 0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  //Row 1
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        containerTankRecord!
                                                            .tankName!, //replace with $tankname variable
                                                        // Text(text.length > 8 ? '${text.substring(0, 8)}...' : text); for input variable $text
                                                        style: GoogleFonts
                                                            .leagueSpartan(
                                                          fontSize: 30,
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis, // new
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  //Row2
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Column(
                                                      //row2 column1
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Row(
                                                          //row2 column1 subrow1
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text('Tank Filled',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .leagueSpartan(
                                                                  fontSize: 16,
                                                                  color: Color(
                                                                      0xFFFFFFFF),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                )),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        Row(
                                                          //row2 column1 subrow2
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                isActive
                                                                    ? functions.convertToInt(functions.tankAPI(functions.calculateWaterAvailable(containerTankRecord.length!, containerTankRecord.breadth!, containerTankRecord.height!, containerTankRecord.radius!, _model.waterLevel, containerTankRecord.isCuboid!), containerTankRecord.capacity)).toString() +
                                                                        " %"
                                                                    : 'N/A', //replace with original data
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .leagueSpartan(
                                                                  fontSize: 24,
                                                                  color: Color(
                                                                      0xFF91D9E9),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      //row2 column2
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Row(
                                                          //row2 column2 subrow1
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                'Available for use',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .leagueSpartan(
                                                                  fontSize: 16,
                                                                  color: Color(
                                                                      0xFFFFFFFF),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                )),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        Row(
                                                          //row2 column2 subrow2
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                isActive
                                                                    ? functions.shortenNumber(functions.calculateWaterAvailable(
                                                                            containerTankRecord
                                                                                .length!,
                                                                            containerTankRecord
                                                                                .breadth!,
                                                                            containerTankRecord
                                                                                .height!,
                                                                            containerTankRecord
                                                                                .radius!,
                                                                            _model
                                                                                .waterLevel,
                                                                            containerTankRecord
                                                                                .isCuboid!)) +
                                                                        "L"
                                                                    : 'N/A', //replace with oririginal data
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .leagueSpartan(
                                                                  fontSize: 24,
                                                                  color: Color(
                                                                      0xFF91D9E9),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  //Row3
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Column(
                                                      //row3 column1
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Row(
                                                          //row3 column1 subrow1
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text('Total Volume',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .leagueSpartan(
                                                                  fontSize: 16,
                                                                  color: Color(
                                                                      0xFFFFFFFF),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                )),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        Row(
                                                          //row3 column1 subrow2
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                isActive
                                                                    ? functions.shortenNumber(containerTankRecord
                                                                            .capacity!) +
                                                                        'L'
                                                                    : 'N/A', //replace with oririginal data
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .leagueSpartan(
                                                                  fontSize: 24,
                                                                  color: Color(
                                                                      0xFF91D9E9),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      //row3 column2
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Row(
                                                          //row3 column2 subrow1
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text('Temperature',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .leagueSpartan(
                                                                  fontSize: 16,
                                                                  color: Color(
                                                                      0xFFFFFFFF),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                )),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        Row(
                                                          //row3 column2 subrow2
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                isActive
                                                                    ? _model.temperature
                                                                            .toString() +
                                                                        ' \u00B0C'
                                                                    : 'N/A', //replace with original data
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .leagueSpartan(
                                                                  fontSize: 24,
                                                                  color: Color(
                                                                      0xFF91D9E9),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  //Row4
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton.icon(
                                                      // <-- ElevatedButton
                                                      onPressed: () async {
                                                        isActive = await functions
                                                            .checkActivity(
                                                                FFAppState()
                                                                    .tankKey);
                                                        _model.waterLevel = await actions.callAPI(
                                                            functions.generateChannelID(
                                                                containerTankRecord
                                                                    .tankKey!),
                                                            functions.generateReadAPI(
                                                                containerTankRecord
                                                                    .tankKey!));
                                                        _model.temperature = await callAPITemperature(
                                                            functions.generateChannelID(
                                                                containerTankRecord
                                                                    .tankKey!),
                                                            functions.generateReadAPI(
                                                                containerTankRecord
                                                                    .tankKey!));
                                                        setState(() {});
                                                      },
                                                      icon: Icon(
                                                        CupertinoIcons
                                                            .arrow_2_squarepath,
                                                        size: 16.0,
                                                        color:
                                                            Color(0xFF0C0C0C),
                                                      ),
                                                      label: Text(
                                                        'Refresh',
                                                        style: GoogleFonts
                                                            .leagueSpartan(
                                                          fontSize: 16,
                                                          color:
                                                              Color(0xFF0C0C0C),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      7.5),
                                                        ),
                                                        backgroundColor:
                                                            Color(0xFFC6DDDB),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 40, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tank Summary',
                                      style: GoogleFonts.leagueSpartan(
                                        fontSize: 24,
                                        color: Color(0xFFFFFFFF),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF1A1A1A),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Color(0xFF656565),
                                            width: 1,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15, 0, 15, 0),
                                          child: DropdownButton<String>(
                                            value: dropdownValueStarr,
                                            // borderRadius: BorderRadius.circular(5),
                                            dropdownColor: Color(0xFF1A1A1A),
                                            focusColor: Color(0xFF1A1A1A),

                                            icon: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Icon(
                                                  CupertinoIcons
                                                      .arrow_turn_right_down,
                                                  size: 14,
                                                )),
                                            iconEnabledColor:
                                                Color(0xFF656565), //Icon color
                                            underline: Container(),
                                            items: <String>[
                                              'Daily',
                                              'Weekly',
                                              'Monthly'
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value,
                                                    style: GoogleFonts
                                                        .leagueSpartan(
                                                      fontSize: 14,
                                                      color: Color(0xFFFFFFFF),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    )),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownValueStarr = newValue!;
                                              });
                                            },
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    15, 20, 15, 0),
                                child: Container(
                                  height: 200,
                                  child: FutureBuilder<SfCartesianChart>(
                                    // replace with following call
                                    future: functions.getChartStarr(
                                        containerTankRecord.tankKey,
                                        dropdownValueStarr,
                                        containerTankRecord.length!,
                                        containerTankRecord.breadth!,
                                        containerTankRecord.height!,
                                        containerTankRecord.radius!,
                                        containerTankRecord.capacity!,
                                        containerTankRecord.isCuboid!),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            'Error occured in loading graph.');
                                      } else {
                                        return snapshot.data ??
                                            SizedBox(); // Render the chart or an empty SizedBox if data is null
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 30, 20, 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        _model.output =
                                            await actions.newCustomAction(
                                          (currentUserDocument?.keyList
                                                      ?.toList() ??
                                                  [])
                                              .toList(),
                                        );

                                        context.pushNamed(
                                          'TankSummary',
                                          queryParams: {
                                            'water': serializeParam(
                                              _model.output,
                                              ParamType.JSON,
                                            ),
                                          }.withoutNulls,
                                        );

                                        setState(() {});
                                      },
                                      child: Text(
                                        'Show All Devices',
                                        style: GoogleFonts.leagueSpartan(
                                          fontSize: 18,
                                          color: Color(0xFF0C0C0C),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.5),
                                          ),
                                          backgroundColor: Color(0xFFC6DDDB),
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 17, 20, 17)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // ),
      ),
      SingleChildScrollView(
        child: Container(
          color: Color(0xFF0C0C0C),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 25, 20, 0),
                child: Text(
                  'Hi,',
                  style: GoogleFonts.leagueSpartan(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w600,
                      fontSize: 40),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 5, 20, 0),
                child: Text(
                  currentUserDisplayName, //replace with $username
                  style: GoogleFonts.leagueSpartan(
                      color: Color(0xFF2F9DC1),
                      fontWeight: FontWeight.w600,
                      fontSize: 40),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                child: Text(
                  '$date',
                  style: GoogleFonts.leagueSpartan(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.normal,
                      fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 20),
                child: StreamBuilder<List<MeterRecord>>(
                  stream: queryMeterRecord(
                    parent: currentUserReference,
                    queryBuilder: (meterRecord) => meterRecord.where('MeterKey',
                        isEqualTo: FFAppState().meterKey),
                    singleRecord: true,
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 75,
                          height: 75,
                          child: SpinKitRipple(
                            color: Color(0xFF7E8083),
                            size: 75,
                          ),
                        ),
                      );
                    }
                    List<MeterRecord> meterRecordList = snapshot.data!;
                    if (snapshot.data!.isEmpty) {
                      return Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PrimaryMeterWidget()));
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Color(0xFF686868)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Default Meter is not selected. \nClick to select a Default Meter.',
                                    style: GoogleFonts.leagueSpartan(
                                      height: 1.5,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    }
                    final meterRecord = meterRecordList.isNotEmpty
                        ? meterRecordList.first
                        : null;
                    return Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        Column(mainAxisSize: MainAxisSize.max, children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(15, 20, 15, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Color(0xded2ecf2),
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Positioned(
                                    child: Center(
                                      child: gauges.SfRadialGauge(
                                        animationDuration: 2000,
                                        enableLoadingAnimation: true,
                                        axes: <gauges.RadialAxis>[
                                          gauges.RadialAxis(
                                            minimum: 0,
                                            maximum: 100,
                                            radiusFactor: 1,
                                            minorTicksPerInterval: 5,
                                            startAngle: 110,
                                            endAngle: 70,
                                            showLabels: false,
                                            axisLineStyle: gauges.AxisLineStyle(
                                              thickness: 0.1,
                                              thicknessUnit:
                                                  gauges.GaugeSizeUnit.factor,
                                              cornerStyle:
                                                  gauges.CornerStyle.bothCurve,
                                              color: Color(0xFF0C0C0C),
                                            ),
                                            majorTickStyle:
                                                gauges.MajorTickStyle(
                                                    length: 0.075,
                                                    lengthUnit: gauges
                                                        .GaugeSizeUnit.factor,
                                                    color: Color(0xFF0c0c0c)
                                                    // color: Color(0xb1bbe5ef),
                                                    ),
                                            minorTickStyle:
                                                gauges.MinorTickStyle(
                                              // color: Color(0x7bbbe5ef),
                                              color: Color(0xFF0c0c0c),
                                              length: 0.05,
                                              lengthUnit:
                                                  gauges.GaugeSizeUnit.factor,
                                            ),
                                            pointers: [
                                              gauges.RangePointer(
                                                width: 0.087,
                                                sizeUnit:
                                                    gauges.GaugeSizeUnit.factor,
                                                value: _pointerValue,
                                                cornerStyle: gauges
                                                    .CornerStyle.bothCurve,
                                                color: Color(0xff37a8d4),
                                              ),
                                              gauges.NeedlePointer(
                                                value: _pointerValue,
                                                needleStartWidth: 1,
                                                needleEndWidth: 5,
                                                needleLength: 8,
                                                needleColor: Color(0x770c0c0c),
                                                knobStyle: gauges.KnobStyle(
                                                  knobRadius: 5,
                                                  sizeUnit: gauges.GaugeSizeUnit
                                                      .logicalPixel,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      child: Center(
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        decoration: BoxDecoration(
                                          color: Color(0xd80c0c0c),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            50, 0, 50, 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              //Row 1
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    meterRecord!.meterName!,
                                                    // Text(text.length > 8 ? '${text.substring(0, 8)}...' : text); for input variable $text
                                                    style: GoogleFonts
                                                        .leagueSpartan(
                                                      fontSize: 30,
                                                      color: Color(0xFFFFFFFF),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    overflow: TextOverflow
                                                        .ellipsis, // new
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              //Row2
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Column(
                                                  //row2 column1
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Row(
                                                      //row2 column1 subrow1
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('Reading',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .leagueSpartan(
                                                              fontSize: 16,
                                                              color: Color(
                                                                  0xFFFFFFFF),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 7,
                                                    ),
                                                    Row(
                                                      //row2 column1 subrow2
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        isActivePravah
                                                            ? FutureBuilder<
                                                                dynamic>(
                                                                future: functions
                                                                    .getReading(
                                                                        meterRecord
                                                                            .meterKey!),
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot<
                                                                            dynamic>
                                                                        snapshot) {
                                                                  if (snapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting) {
                                                                    return CircularProgressIndicator(); // Display a loading indicator while waiting for the result
                                                                  } else if (snapshot
                                                                      .hasError) {
                                                                    return Text(
                                                                        'Error: ${snapshot.error}');
                                                                  } else {
                                                                    var value =
                                                                        snapshot
                                                                            .data;
                                                                    return Text(
                                                                        // value
                                                                        //     .toString(),
                                                                        functions.shortenNumber(value) +
                                                                            "L",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: GoogleFonts
                                                                            .leagueSpartan(
                                                                          fontSize:
                                                                              24,
                                                                          color:
                                                                              Color(0xFF91D9E9),
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ));
                                                                  }
                                                                },
                                                              )
                                                            : Text('N/A',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .leagueSpartan(
                                                                  fontSize: 24,
                                                                  color: Color(
                                                                      0xFF91D9E9),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  //row2 column2
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Row(
                                                      //row2 column2 subrow1
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('Flow Rate',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .leagueSpartan(
                                                              fontSize: 16,
                                                              color: Color(
                                                                  0xFFFFFFFF),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 7,
                                                    ),
                                                    Row(
                                                      //row2 column2 subrow2
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        isActivePravah
                                                            ? FutureBuilder<
                                                                dynamic>(
                                                                future: functions
                                                                    .getFlowRate(
                                                                        meterRecord
                                                                            .meterKey!),
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot<
                                                                            dynamic>
                                                                        snapshot) {
                                                                  if (snapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting) {
                                                                    return CircularProgressIndicator(); // Display a loading indicator while waiting for the result
                                                                  } else if (snapshot
                                                                      .hasError) {
                                                                    return Text(
                                                                        'Error: ${snapshot.error}');
                                                                  } else {
                                                                    var value =
                                                                        snapshot
                                                                            .data;
                                                                    return Text(
                                                                        value
                                                                            .toString(),
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: GoogleFonts
                                                                            .leagueSpartan(
                                                                          fontSize:
                                                                              24,
                                                                          color:
                                                                              Color(0xFF91D9E9),
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ));
                                                                  }
                                                                },
                                                              )
                                                            : Text('N/A',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                    .leagueSpartan(
                                                                  fontSize: 24,
                                                                  color: Color(
                                                                      0xFF91D9E9),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              //Row4
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton.icon(
                                                  // <-- ElevatedButton
                                                  onPressed: () async {
                                                    _model.totalFlow =
                                                        await functions
                                                            .getReading(
                                                                meterRecord
                                                                    .meterKey!);
                                                    _model.waterLevel =
                                                        await functions
                                                            .getFlowRate(
                                                                meterRecord
                                                                    .meterKey!);
                                                    setState(() {});
                                                  },
                                                  icon: Icon(
                                                    CupertinoIcons
                                                        .arrow_2_squarepath,
                                                    size: 16.0,
                                                    color: Color(0xFF0C0C0C),
                                                  ),
                                                  label: Text(
                                                    'Refresh',
                                                    style: GoogleFonts
                                                        .leagueSpartan(
                                                      fontSize: 16,
                                                      color: Color(0xFF0C0C0C),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.5),
                                                    ),
                                                    backgroundColor:
                                                        Color(0xFFC6DDDB),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )),
                                  )),
                                ],
                              ),
                            ),
                          ),

                          // Total Flow Chart
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 40, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Flow Summary',
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 24,
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1A1A1A),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Color(0xFF656565),
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15, 0, 15, 0),
                                      child: DropdownButton<String>(
                                        value: dropdownValuePravahTotal,
                                        // borderRadius: BorderRadius.circular(5),
                                        dropdownColor: Color(0xFF1A1A1A),
                                        focusColor: Color(0xFF1A1A1A),

                                        icon: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Icon(
                                              CupertinoIcons
                                                  .arrow_turn_right_down,
                                              size: 14,
                                            )),
                                        iconEnabledColor:
                                            Color(0xFF656565), //Icon color
                                        underline: Container(),
                                        items: <String>[
                                          'Daily',
                                          'Weekly',
                                          'Monthly'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,
                                                style:
                                                    GoogleFonts.leagueSpartan(
                                                  fontSize: 14,
                                                  color: Color(0xFFFFFFFF),
                                                  fontWeight: FontWeight.normal,
                                                )),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValuePravahTotal =
                                                newValue!;
                                          });
                                        },
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          // graph - library to be updated as per the data
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(15, 20, 15, 0),
                            child: Container(
                              height: 200,
                              child: FutureBuilder<SfCartesianChart>(
                                future: functions.getChartPravahTotal(
                                    meterRecord.meterKey!,
                                    dropdownValuePravahTotal),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        'Error occured in loading graph.');
                                  } else {
                                    return snapshot.data ??
                                        SizedBox(); // Render the chart or an empty SizedBox if data is null
                                  }
                                },
                              ),
                            ),
                          ),

                          // Flow Rate Chart
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 40, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Flow Rate Summary',
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 24,
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1A1A1A),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Color(0xFF656565),
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15, 0, 15, 0),
                                      child: DropdownButton<String>(
                                        value: dropdownValuePravahRate,
                                        // borderRadius: BorderRadius.circular(5),
                                        dropdownColor: Color(0xFF1A1A1A),
                                        focusColor: Color(0xFF1A1A1A),

                                        icon: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Icon(
                                              CupertinoIcons
                                                  .arrow_turn_right_down,
                                              size: 14,
                                            )),
                                        iconEnabledColor:
                                            Color(0xFF656565), //Icon color
                                        underline: Container(),
                                        items: <String>[
                                          'Daily',
                                          'Weekly',
                                          'Monthly'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,
                                                style:
                                                    GoogleFonts.leagueSpartan(
                                                  fontSize: 14,
                                                  color: Color(0xFFFFFFFF),
                                                  fontWeight: FontWeight.normal,
                                                )),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValuePravahRate = newValue!;
                                          });
                                        },
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          // graph - library to be updated as per the data
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(15, 20, 15, 0),
                            child: Container(
                              height: 200,
                              child: FutureBuilder<SfCartesianChart>(
                                future: functions.getChartPravahRate(
                                    meterRecord.meterKey!,
                                    dropdownValuePravahRate),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        'Error occured in loading graph.');
                                  } else {
                                    return snapshot.data ??
                                        SizedBox(); // Render the chart or an empty SizedBox if data is null
                                  }
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 30, 20, 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    _model.outputPravah =
                                        await newCustomActionPravah(
                                      (currentUserDocument?.meterKeyList
                                                  ?.toList() ??
                                              [])
                                          .toList(),
                                    );

                                    context.pushNamed(
                                      'MeterSummary',
                                      queryParams: {
                                        'reading': serializeParam(
                                          _model.outputPravah,
                                          ParamType.JSON,
                                        ),
                                      }.withoutNulls,
                                    );

                                    setState(() {});
                                  },
                                  child: Text(
                                    'Show All Devices',
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize: 18,
                                      color: Color(0xFF0C0C0C),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.5),
                                      ),
                                      backgroundColor: Color(0xFFC6DDDB),
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 17, 20, 17)),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Color(0xFF0C0C0C),
      endDrawer: drawers.elementAt(selectedindex),
      appBar: AppBar(
        backgroundColor: Color(0xFF112025),
        title: Text(
          'Hydrow Verse',
          style: GoogleFonts.leagueSpartan(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.normal,
            fontSize: 22,
          ),
        ),
      ),
      //It will select the Starr or Pravah dashboard based of selectedindex value
      body: pages.elementAt(selectedindex),
      //Bottom navigation bar of Starr and Pravah
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF112025),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.invert_colors,
            ),
            label: 'Starr',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.show_chart),
            label: 'Pravah',
          ),
        ],
        currentIndex: selectedindex,
        selectedLabelStyle: GoogleFonts.leagueSpartan(
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        unselectedLabelStyle: GoogleFonts.leagueSpartan(
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        unselectedItemColor: Colors.white,
        selectedItemColor: Color(0xFF93DCEC),
        onTap: onTapItem,
      ),
    );
  }

//Switching of index value upon clicking
  void onTapItem(int index) {
    setState(() {
      selectedindex = index;
    });
  }
}

class AddDevices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Drawer());
  }
}
