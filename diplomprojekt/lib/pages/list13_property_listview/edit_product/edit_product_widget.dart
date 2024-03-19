import 'dart:io';

import 'package:diplomprojekt/fetch.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'edit_product_model.dart';
export 'edit_product_model.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

import 'package:image_picker/image_picker.dart';

class EditProductWidget extends StatefulWidget {
  final String title;
  final List<Uint8List> imageBytesList;
  final String description;
  final int postcode;
  final double price;
  final String condition;
  final String category;
  final String delivery;

  const EditProductWidget({
    Key? key,
    required this.title,
    required this.imageBytesList,
    required this.description,
    required this.postcode,
    required this.price,
    required this.condition,
    required this.category,
    required this.delivery,
  }) : super(key: key);

  @override
  State<EditProductWidget> createState() => _EditProductWidgetState();
}

class _EditProductWidgetState extends State<EditProductWidget>
    with TickerProviderStateMixin {
  late EditProductModel _model;

  bool isUploading = false;

  void startUpload() async {
    setState(() {
      isUploading = true; // Starte den Upload und zeige den Spinner
    });
  }

  List<XFile>? selectedImages = [];
  List<Uint8List> imageBytesList = [];

  Future<void> selectAndUploadImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      if (kIsWeb) {
        List<Uint8List> newImageBytesList =
            await Future.wait(images.map((image) => image.readAsBytes()));
        setState(() {
          imageBytesList
              .addAll(newImageBytesList); // Hinzufügen neuer Bilder zur Liste
        });
      } else {
        print("Keine Bilder ausgewählt");
      }
    }
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 110.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProductModel());

    _model.textController1 ??= TextEditingController(text: widget.title);
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(text: widget.description);
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController(text: widget.postcode.toString());
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController(text: widget.price.toString());
    _model.textFieldFocusNode4 ??= FocusNode();

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF606A85),
              size: 30.0,
            ),
            onPressed: () async {
              context.pushNamed('List13PropertyListview');
            },
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Produktanzeige aktualisieren',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          color: Color(0xFF15161E),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                    child: Text(
                      'Füllen Sie das nachstehende Formular aus, um Ihren Artikel auf dem Marktplatz zu listen.',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Plus Jakarta Sans',
                            color: Color(0xFF606A85),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                        child: Container(
                          height: 200.0, // Höhe des Containers festlegen
                          child: imageBytesList.isEmpty
                              ? Image.asset(
                                  'assets/images/istockphoto-1226328537-612x612.jpg',
                                  width: 400.0,
                                  height: 400.0,
                                  fit: BoxFit.cover,
                                )
                              : ListView.builder(
                                  scrollDirection: Axis
                                      .horizontal, // Horizontale Scroll-Richtung
                                  itemCount: imageBytesList
                                      .length, // Anzahl der Bilder in der Liste
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          right:
                                              8.0), // Abstand zwischen den Bildern
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: Image.memory(
                                          imageBytesList[
                                              index], // Zugriff auf das Bild an Position index
                                          width: 400.0, // Breite jedes Bildes
                                          fit: BoxFit
                                              .cover, // Bild an den ClipRRect anpassen
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: GestureDetector(
                          onTap: () async {
                            selectAndUploadImages();
                          },
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxWidth: 500.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Color(0xFFE5E7EB),
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_rounded,
                                    color: Color(0xFF81AC26),
                                    size: 32.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Produktbilder hochladen',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            color: Color(0xFF15161E),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ).animateOnPageLoad(
                          animationsMap['containerOnPageLoadAnimation']!),
                      TextFormField(
                        controller: _model.textController1,
                        focusNode: _model.textFieldFocusNode1,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Produktname...',
                          labelStyle: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Outfit',
                                color: Color(0xFF606A85),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                          hintStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Color(0xFF606A85),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFE5E7EB),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF387B2E),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFFF5963),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFFF5963),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 12.0, 16.0, 12.0),
                        ),
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF15161E),
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                        cursorColor: Color(0xFF6F61EF),
                        validator: _model.textController1Validator
                            .asValidator(context),
                      ),
                      TextFormField(
                        controller: _model.textController2,
                        focusNode: _model.textFieldFocusNode2,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Color(0xFF606A85),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                          hintText:
                              'Geben Sie eine detaillierte Beschreibung Ihres Artikels an, einschließlich der Hauptmerkmale, Zustands und besonderer Details, die Käufer wissen sollten...',
                          hintStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Color(0xFF606A85),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFE5E7EB),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF387B2E),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFFF5963),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFFF5963),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 24.0, 16.0, 12.0),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xFF15161E),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                        maxLines: 16,
                        minLines: 6,
                        cursorColor: Color(0xFF6F61EF),
                        validator: _model.textController2Validator
                            .asValidator(context),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          FlutterFlowDropDown<String>(
                            controller: _model.dropDownValueController ??=
                                FormFieldController<String>(null),
                            options: [
                              'Desktop Komplettsysteme',
                              'Barebone-PCs',
                              'Laptops & Notebooks',
                              'Tablets',
                              'Smartphones & Handys',
                              'Server-Hardware',
                              'Workstations',
                              'Festplatten (HDD)',
                              'Solid State Drives (SSD)',
                              'Externe Speicherlösungen',
                              'USB-Sticks',
                              'Speicherkarten (SD-Karten)',
                              'Motherboards (für Intel CPUs)',
                              'Motherboards (für AMD CPUs)',
                              'Intel Prozessoren (CPU)',
                              'AMD Prozessoren (CPU)',
                              'NVIDIA Grafikkarten (GPU)',
                              'AMD Grafikkarten (GPU)',
                              'DDR4 Arbeitsspeicher (RAM)',
                              'DDR3 Arbeitsspeicher (RAM)',
                              'Netzteile (PSU)',
                              'Kühlung und Lüftung',
                              'CPU-Kühler',
                              'Gehäuselüfter',
                              'Tastaturen',
                              'Mäuse',
                              'Game Controller',
                              'sonstige Eingabegeräte',
                              'Monitore & Displays',
                              'Drucker & Scanner',
                              'Router',
                              'Switches',
                              'WLAN-Adapter',
                              'sonstige Netzwerkkomponenten',
                              'Kopfhörer und Headsets',
                              'Mikrofone',
                              'Lautsprecher',
                              'sonstige Multimediageräte',
                              'Mikrocontroller',
                              'Raspberry Pi',
                              'Arduino',
                              'FPGA-Boards',
                              'sonstige Komponenten & Module',
                              'IoT-Kits',
                              'Roboter-Bausätze',
                              'sonstige Entwicklerboards & Experimentierkits',
                              'Betriebssysteme',
                              'Office-Software',
                              'Entwicklertools',
                              'sonstige Software & Betriebssysteme',
                              'HDMI Kabel',
                              'USB Kabel',
                              'Netzwerkkabel',
                              'sonstige Kabel & Adapter',
                              'Akkus',
                              'Ladegeräte',
                              'USV-Anlagen',
                              'sonstige Stromversorgung & Batterien'
                            ],
                            onChanged: (val) =>
                                setState(() => _model.dropDownValue = val),
                            width: 300.0,
                            height: 50.0,
                            textStyle: FlutterFlowTheme.of(context).bodyMedium,
                            hintText: 'Kategorie auswählen...',
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            elevation: 2.0,
                            borderColor: FlutterFlowTheme.of(context).alternate,
                            borderWidth: 2.0,
                            borderRadius: 8.0,
                            margin: EdgeInsetsDirectional.fromSTEB(
                                16.0, 4.0, 16.0, 4.0),
                            hidesUnderline: true,
                            isOverButton: true,
                            isSearchable: false,
                            isMultiSelect: false,
                          ),
                        ],
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        child: FlutterFlowChoiceChips(
                          options: [
                            ChipData('Neu'),
                            ChipData('Gebraucht'),
                            ChipData('Defekt')
                          ],
                          onChanged: (val) => setState(() =>
                              _model.choiceChipsValue1 = val?.firstOrNull),
                          selectedChipStyle: ChipStyle(
                            backgroundColor: Color(0xFF387B2E),
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                ),
                            iconColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            iconSize: 18.0,
                            elevation: 4.0,
                            borderWidth: 2.0,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          unselectedChipStyle: ChipStyle(
                            backgroundColor:
                                FlutterFlowTheme.of(context).alternate,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                            iconColor: FlutterFlowTheme.of(context).alternate,
                            iconSize: 18.0,
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          chipSpacing: 12.0,
                          rowSpacing: 12.0,
                          multiselect: false,
                          alignment: WrapAlignment.start,
                          controller: _model.choiceChipsValueController1 ??=
                              FormFieldController<List<String>>(
                            [],
                          ),
                          wrapped: true,
                        ),
                      ),
                      FlutterFlowChoiceChips(
                        options: [
                          ChipData('Abholung', Icons.people_outline),
                          ChipData('Versand', Icons.local_post_office_outlined)
                        ],
                        onChanged: (val) => setState(
                            () => _model.choiceChipsValue2 = val?.firstOrNull),
                        selectedChipStyle: ChipStyle(
                          backgroundColor: Color(0xFF387B2E),
                          textStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                          iconColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          iconSize: 18.0,
                          elevation: 0.0,
                          borderWidth: 2.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        unselectedChipStyle: ChipStyle(
                          backgroundColor:
                              FlutterFlowTheme.of(context).alternate,
                          textStyle: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Readex Pro',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                          iconColor: FlutterFlowTheme.of(context).secondaryText,
                          iconSize: 18.0,
                          elevation: 0.0,
                          borderWidth: 2.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        chipSpacing: 12.0,
                        rowSpacing: 12.0,
                        multiselect: false,
                        alignment: WrapAlignment.start,
                        controller: _model.choiceChipsValueController2 ??=
                            FormFieldController<List<String>>(
                          [],
                        ),
                        wrapped: true,
                      ),
                      Container(
                        height: 50.0,
                        decoration: BoxDecoration(),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 0.0),
                            child: TextFormField(
                              controller: _model.textController3,
                              focusNode: _model.textFieldFocusNode3,
                              onFieldSubmitted: (_) async {
                                context.pushNamed('List13PropertyListview');
                              },
                              autofocus: true,
                              autofillHints: [AutofillHints.postalCode],
                              obscureText: false,
                              keyboardType: TextInputType
                                  .number, // Erlaube nur numerische Eingaben
                              maxLength: 5, // Maximale Länge auf 5 setzen
                              decoration: InputDecoration(
                                labelText: 'Postleitzahl hier eingeben...',
                                counterText: '',
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                hintStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF387B2E),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.w500,
                                  ),
                              validator: _model.textController3Validator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 250.0, 0.0),
                          child: TextFormField(
                            controller: _model.textController4,
                            focusNode: _model.textFieldFocusNode4,
                            autofocus: true,
                            obscureText: false,
                            maxLength: 3,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Preis in €',
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 30.0,
                                  ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF387B2E),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            style: FlutterFlowTheme.of(context).bodyLarge,
                            validator: _model.textController4Validator
                                .asValidator(context),
                          ),
                        ),
                      ),
                    ]
                        .divide(SizedBox(height: 16.0))
                        .addToStart(SizedBox(height: 12.0)),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 12.0),
                    child: FFButtonWidget(
                      onPressed: isUploading
                          ? null
                          : () async {
                              String title = _model.textController1.text;
                              String description = _model.textController2.text;
                              String? category = _model.dropDownValue;
                              String? condition = _model.choiceChipsValue1;
                              String? delivery = _model.choiceChipsValue2;
                              String postcode = _model.textController3.text;
                              String price = _model.textController4.text;

                              // Call the create_product method with the title and description
                              bool uploadSuccessful = await create_product(
                                  title,
                                  description,
                                  category!,
                                  condition!,
                                  delivery!,
                                  postcode,
                                  price,
                                  imageBytesList);

                              setState(() {
                                isUploading =
                                    false; // Beende den Upload und verstecke den Spinner
                              });
                              if (uploadSuccessful) {
                                context.pushNamed('List13PropertyListview');
                              }
                            },
                      text: 'Anzeige hochladen ',
                      icon: isUploading
                          ? null
                          : Icon(
                              Icons.receipt_long,
                              size: 15.0,
                            ),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 54.0,
                        color: Color(0xFF81AC26),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                        elevation: 4.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
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