/*
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
*/
import 'package:flutter/cupertino.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_device_q_r_scan_pravah_model.dart';
export 'add_device_q_r_scan_pravah_model.dart';

class AddDeviceQRScanPravahWidget extends StatefulWidget {
  const AddDeviceQRScanPravahWidget({Key? key}) : super(key: key);

  @override
  _AddDeviceQRScanPravahWidgetState createState() =>
      _AddDeviceQRScanPravahWidgetState();
}

class _AddDeviceQRScanPravahWidgetState
    extends State<AddDeviceQRScanPravahWidget> with TickerProviderStateMixin {
  late AddDeviceQRScanPravahModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeIn,
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
    _model = createModel(context, () => AddDeviceQRScanPravahModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.lockOrientation();
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

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF0C0C0C),
        appBar: AppBar(
          backgroundColor: Color(0xFF112025),
          title: Text(
            'Add Device - QR Scan',
            style: GoogleFonts.leagueSpartan(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.normal,
              fontSize: 20, //edited
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          10.0, 250.0, 10.0, 0.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Color(0x33536765),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x33000000),
                                offset: Offset(0.0, 2.0),
                              )
                            ],
                            borderRadius: BorderRadius.circular(20.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 20.0, 20.0, 20.0),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 20.0, 10.0, 30.0),
                                            child: Text(
                                                'Scan the QR to proceed further',
                                                textAlign: TextAlign.center,
                                                style:
                                                    GoogleFonts.leagueSpartan(
                                                  color: Color(0xFFFFFFFF),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 24,
                                                )),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 25.0),
                                          child: ElevatedButton.icon(
                                            onPressed: () async {
                                              _model.qROutput =
                                                  await FlutterBarcodeScanner
                                                      .scanBarcode(
                                                '#C62828', // scanning line color
                                                'Cancel', // cancel button text
                                                true, // whether to show the flash icon
                                                ScanMode.QR,
                                              );

                                              if (functions
                                                  .qrPravah(_model.qROutput)) {
                                                context.pushNamed(
                                                  'AddDevicePravah',
                                                  queryParams: {
                                                    'meterKey': serializeParam(
                                                      _model.qROutput,
                                                      ParamType.String,
                                                    ),
                                                  }.withoutNulls,
                                                );
                                              } else {
                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text('Error'),
                                                      content: Text(
                                                          'QR wasn\'t scanned successfully. Try again and please check that you are scanning the right QR.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext),
                                                          child: Text('Ok'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );

                                                context.pop();
                                                context.pushNamed(
                                                    'AddDeviceQRScan');
                                              }

                                              setState(() {});
                                            },
                                            icon: Icon(
                                              CupertinoIcons.qrcode_viewfinder,
                                              size: 18.0,
                                              color: Color(0xFF0C0C0C),
                                            ),
                                            label: Text(
                                              'Scan QR',
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
                                              backgroundColor:
                                                  Color(0xFFC6DDDB),
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 17, 20, 17),
                                            ),
                                          ),
                                        ),
                                      ])))))
                ])),
          ),
        ));
  }
}
