import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;


void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage()
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
  if (_userController.text == "demo" && _passwordController.text == "8888") {
    // Mostrar ventana emergente para llenar información del paciente
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PatientInfoDialog(
          onConfirm: (patientData, heaFile, datFile) {
            
            Navigator.pop(context); // cerrar el diálogo
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyoAlertPage(
                  patientData: patientData,
                ),
              ),
            );
          },
        );
      },
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Usuario o contraseña incorrectos")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 53, 159, 246), // azul fuerte
              Color.fromARGB(255, 174, 214, 241), // azul claro
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 650,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(FontAwesomeIcons.heartPulse,
                        color: Color(0xFF2196F3), size: 35),
                    const SizedBox(height: 10),
                    const Text(
                      "MyoAlert Vision",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Usuario
                    TextField(
                      controller: _userController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline),
                        labelText: "Usuario",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Contraseña
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        labelText: "Contraseña",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Botón login
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: const Color(0xFF2196F3),
                        ),
                        child: const Text(
                          "Iniciar sesión",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                  ],
                ),
              ),
            ),
          ),
        ),
      )
      ),
    );
  
  }
}



class PatientInfoDialog extends StatefulWidget {
  final Function(Map<String, dynamic>, PlatformFile?, PlatformFile?) onConfirm;

  const PatientInfoDialog({super.key, required this.onConfirm});

  @override
  State<PatientInfoDialog> createState() => _PatientInfoDialogState();
}

class _PatientInfoDialogState extends State<PatientInfoDialog> {
  final _nameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _ageController = TextEditingController();
  final _commentsController = TextEditingController();
  String? _idType;
  DateTime _selectedDate = DateTime.now();
  final DateTime selectedDateTime = DateTime.now();

  PlatformFile? _heaFile;
  PlatformFile? _datFile;

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['hea', 'dat'],
    );

    if (result == null) return;

    setState(() {
      _heaFile = result.files.firstWhere(
        (f) => f.name.endsWith('.hea'),
        orElse: () => _heaFile!,
      );
      _datFile = result.files.firstWhere(
        (f) => f.name.endsWith('.dat'),
        orElse: () => _datFile!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Información del paciente"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _idType,
              items: const [
                DropdownMenuItem(value: "CC", child: Text("CC")),
                DropdownMenuItem(value: "TI", child: Text("TI")),
                DropdownMenuItem(value: "CE", child: Text("CE")),
              ],
              onChanged: (val) => setState(() => _idType = val),
              decoration: const InputDecoration(labelText: "Tipo de identificación"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _idNumberController,
              decoration: const InputDecoration(labelText: "Número de identificación"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: "Edad"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Fecha y hora: ${_selectedDate.toLocal()}".split('.')[0],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // cancelar
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            final patientData = {
              "nombre": _nameController.text,
              "tipoId": _idType,
              "numeroId": _idNumberController.text,
              "edad": _ageController.text,
              "fecha": _selectedDate.toString(),
              "comentarios": _commentsController.text,
            };
            widget.onConfirm(patientData, _heaFile, _datFile);
          },
          child: const Text("Confirmar"),
        ),
      ],
    );
  }
}


class MyoAlertPage extends StatefulWidget {
  final Map<String, dynamic> patientData;

  const MyoAlertPage({super.key,required this.patientData});

  @override
  State<MyoAlertPage> createState() => _MyoAlertPageState();
}

class _MyoAlertPageState extends State<MyoAlertPage> {
   Map<String, dynamic> patientData = {};

  String? heaFileName;
  String? datFileName;
  double? probXGBoost;
  double? probCNN;
  String? infarctLocation;
  Uint8List? ecgImageBytes;
  List<List<double>> ecgSignals = [];
  List<String> ecgLeadsFromFile = []; // Nombres de derivadas según .hea
  int? selectedLeadIndex;
  final TextEditingController _commentsController = TextEditingController();

 @override
  void initState() {
    super.initState();
    patientData = Map<String, dynamic>.from(widget.patientData); // copiamos los datos iniciales
  }
 
Future<void> generatePatientPdf(
  Map<String, dynamic> patientData, {
  double? probXGBoost,
  double? probCNN,
  String? infarctLocation,
  Uint8List? ecgImageBytes, // 
}) async {
  final pdf = pw.Document();
  final imageData = await rootBundle.load('assets/fondo.jpg');
  final background = pw.MemoryImage(imageData.buffer.asUint8List());

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.letter,
      margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Encabezado
            pw.Container(
              width: double.infinity,
              height: 45,
              decoration: pw.BoxDecoration(
                image: pw.DecorationImage(
                  image: background,
                  fit: pw.BoxFit.cover,
                ),
              ),
              alignment: pw.Alignment.centerLeft,
              padding: const pw.EdgeInsets.symmetric(horizontal: 10),
              child: pw.Text(
                'MyoAlert Vision',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.SizedBox(height: 15),

            // Información del paciente
            pw.Text('Información del paciente',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text('Nombre: ${patientData["nombre"]}',
                style: pw.TextStyle(fontSize: 10)),
            pw.Text('Tipo de identificación: ${patientData["tipoId"]}',
                style: pw.TextStyle(fontSize: 10)),
            pw.Text('Número de identificación: ${patientData["numeroId"]}',
                style: pw.TextStyle(fontSize: 10)),
            pw.Text('Edad: ${patientData["edad"]}',
                style: pw.TextStyle(fontSize: 10)),
            pw.Text(
                'Fecha y hora del reporte: ${patientData["fecha"]?.split(".").first ?? ""}',
                style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 15),

            // Probabilidades
            pw.Text(
              'Probabilidad de Infarto Agudo de Miocardio con Elevación del Segmento ST',
              style:
                  pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Estimación primaria: ${probXGBoost != null ? (probXGBoost).toStringAsFixed(2) : "--"}%    '
              'Estimación complementaria: ${probCNN != null ? (probCNN).toStringAsFixed(2) : "--"}%',
              style: pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 15),

            // Localización del infarto
            pw.Text('Localización anatómica estimada del infarto',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text(infarctLocation ?? '--', style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 15),

            // Comentarios
            pw.Text('Comentarios',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius:
                    const pw.BorderRadius.all(pw.Radius.circular(5)),
              ),
              child: pw.Text(
                patientData['comentarios'] ?? '',
                style: pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.justify,
              ),
            ),

            pw.SizedBox(height: 15),

            // ECG (imagen debajo de los comentarios)
            pw.Text(
              'Electrocardiograma',
              style: pw.TextStyle(
                  fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),

            if (ecgImageBytes != null)
            pw.Center(
              child: pw.Container(
                width: PdfPageFormat.letter.width - 20,   
                height: PdfPageFormat.letter.availableHeight * 0.5, // misma altura
                alignment: pw.Alignment.center,
                child: pw.Image(
                  pw.MemoryImage(ecgImageBytes),
                  fit: pw.BoxFit.contain, // mantiene proporción
                ),
              ),
            )
            else
              pw.Text(
                'No se ha cargado la imagen del ECG.',
                style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
              ),
          ],
        );
      },
    ),
  );


  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );


}


Future<void> _pickAndProcessFiles() async {
  // Selección de archivos
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true, 
    type: FileType.custom,
    allowedExtensions: ['hea', 'dat'],
  );

  if (result == null) return;

  PlatformFile? heaFile;
  PlatformFile? datFile;

  // Buscar archivos .hea y .dat
  try {
    heaFile = result.files.firstWhere((f) => f.name.endsWith('.hea'));
    datFile = result.files.firstWhere((f) => f.name.endsWith('.dat'));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Debes seleccionar ambos archivos .hea y .dat')),
    );
    return;
  }

  if (heaFile.bytes == null || datFile.bytes == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudieron leer los archivos seleccionados')),
    );
    return;
  }

  // Guardar nombres de archivo de forma segura
  setState(() {
    heaFileName = heaFile!.name;
    datFileName = datFile!.name;
  });

  // --- Leer .hea ---
  String heaContent = utf8.decode(heaFile.bytes!);
  List<String> lines = heaContent.split('\n');
  int numSignals = 12;
  int samples = 500;

  if (lines.isNotEmpty) {
    List<String> header = lines.first.split(' ');
    if (header.length >= 4) {
      numSignals = int.tryParse(header[1]) ?? 12;
      samples = int.tryParse(header[3]) ?? 500;
    }
  }

  ecgLeadsFromFile = [];
  if (lines.length >= numSignals + 1) {
    for (int i = 1; i <= numSignals; i++) {
      List<String> parts = lines[i].split(' ');
      if (parts.isNotEmpty) {
        ecgLeadsFromFile.add(parts.last.trim());
      }
    }
  }
  final indexII =
  ecgLeadsFromFile.indexWhere((lead) => lead.toUpperCase().contains('II'));
  if (indexII != -1) {
    setState(() {
      selectedLeadIndex = indexII;
    });
  }
  // --- Leer .dat ---
  Uint8List datBytes = datFile.bytes!;
  ByteData byteData = datBytes.buffer.asByteData();

  List<List<double>> signals = [];
  for (int ch = 0; ch < numSignals; ch++) {
    List<double> channel = [];
    for (int i = 0; i < samples; i++) {
      int index = (i * numSignals + ch) * 2;
      if (index + 2 <= datBytes.length) {
        int value = byteData.getInt16(index, Endian.little);
        channel.add(value.toDouble());
      }
    }
    signals.add(channel);
  }

  setState(() {
    ecgSignals = signals;
  });

  // ENVÍO AL SERVIDOR PARA MÉTRICAS
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:5000/process_ecg'),
    );

    request.files.add(http.MultipartFile.fromBytes('hea', heaFile.bytes!, filename: heaFile.name));
    request.files.add(http.MultipartFile.fromBytes('dat', datBytes, filename: datFile.name));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          probXGBoost = data['xgboost'] * 100;
          probCNN = data['cnn'] * 100;
          infarctLocation = data['lgb_location'];
          
          //  Decodificar imagen ECG (si viene del backend)
          if (data['ecg_image'] != null) {
            ecgImageBytes = base64Decode(data['ecg_image']);
          }
        });

        print("Prob XGBoost: ${probXGBoost!.toStringAsFixed(2)}%");
        print("Prob CNN: ${probCNN!.toStringAsFixed(2)}%");
        print("Localización: $infarctLocation");
        print("Imagen ECG cargada: ${ecgImageBytes != null}");
      }
    if ((probXGBoost != null && probXGBoost! >= 70) ||
      (probCNN != null && probCNN! >= 70)) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'ALERTA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontFamily: 'Georgia',
              ),
            ),
            content: const SizedBox(
            width: 450, // ajusta el ancho del cuadro aquí
            child: Text(
            'El sistema ha identificado patrones indicativos de un posible Infarto Agudo de Miocardio con Elevación del Segmento ST. '
            'Se recomienda valoración y supervisión médica inmediata.',
            style: TextStyle(fontSize: 14, fontFamily: 'Georgia'),
            textAlign: TextAlign.justify,
            ),
            ),
            backgroundColor: Color.fromARGB(255, 255, 230, 230),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Aceptar', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
  }
  } catch (e) {
    print("Error enviando al servidor: $e");
  }
}


Future<void> sendToServer(
  Uint8List heaBytes,
  Uint8List datBytes,
  String heaName,
  String datName,
) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:5000/process_ecg'),
    );

    request.files.add(http.MultipartFile.fromBytes('hea', heaBytes, filename: heaName));
    request.files.add(http.MultipartFile.fromBytes('dat', datBytes, filename: datName));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      setState(() {
        probXGBoost = data['xgboost'] * 100;
        probCNN = data['cnn'] * 100;
        infarctLocation = data['lgb_location'];

        // 👇 Aquí se decodifica la imagen enviada por el backend
        if (data['ecg_image'] != null) {
          ecgImageBytes = base64Decode(data['ecg_image']);
          print("Imagen ECG recibida (${ecgImageBytes!.lengthInBytes} bytes)");
        } else {
          print("No se recibió imagen ECG");
        }
      });

      print("Prob XGBoost: ${probXGBoost!.toStringAsFixed(2)}%");
      print("Prob CNN: ${probCNN!.toStringAsFixed(2)}%");
      print("Localización: $infarctLocation");
    } else {
      print("Error del servidor: ${response.statusCode}");
    }
  } catch (e) {
    print("Error enviando al servidor: $e");
  }
}




  Widget _buildECGChart(List<double> signal, int index) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: signal.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value);
            }).toList(),
            isCurved: false,
            dotData: FlDotData(show: false),
            color: const Color.fromARGB(255, 14, 120, 207),
            barWidth: 1,
          ),
        ],
        lineTouchData: LineTouchData(
        enabled: false, 
      ),
      ),
    );
  }

  Widget infoBlock(String text) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget modelBlock(String model, String percentage) {
    return Container(
      width: 100,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(model, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(percentage, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  
  
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 40,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(1), // fondo blanco semitransparente
          borderRadius: BorderRadius.circular(0), // bordes redondeados
        ),
        child: Text(
          'MyoAlert Vision',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 4, 116, 186), // color del texto
            fontFamily: 'Georgia',
          ),
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("fondo.jpg"),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
        actions: [
  Container(
    margin: const EdgeInsets.only(right: 0), // pequeño margen derecho
    decoration: BoxDecoration(
      color: Colors.white, // fondo blanco
      borderRadius: BorderRadius.circular(0), // bordes redondeados
    ),
    child: PopupMenuButton<String>(
      icon: const Icon(
        Icons.menu_open,
        color: Color.fromARGB(255, 4, 116, 186),
      ),
      onSelected: (String value) async {
        if (value == 'report') {
          // Actualizamos los comentarios
          patientData['comentarios'] = _commentsController.text;

          // Mostramos el diálogo de carga
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              content: Row(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(width: 10),
                  Text("Descargando reporte..."),
                ],
              ),
            ),
          );

  
        try {
        // Ejecutar PDF directamente 
        await generatePatientPdf(
          patientData,
          probXGBoost: probXGBoost,
          probCNN: probCNN,
          infarctLocation: infarctLocation,
          ecgImageBytes: ecgImageBytes,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al generar PDF: $e")),
        );
      } finally {
        // Cerramos el diálogo cuando termina
        Navigator.of(context).pop();
}
        } else if (value == 'exit') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: 'report',
          child: Text('Descargar reporte'),
        ),
        const PopupMenuItem(
          value: 'exit',
          child: Text('Salir'),
        ),
      ],
    ),
  ),
],
    ),
  
  
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              flex: 75,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bloque de Información de Paciente
                       SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Información del paciente',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Text('Nombre: ${widget.patientData["nombre"] ?? ""}'),
                              Text('Tipo de identificación: ${widget.patientData["tipoId"] ?? ""}'),
                              Text('Número de Identificación: ${widget.patientData["numeroId"] ?? ""}'),
                              Text('Edad: ${widget.patientData["edad"] ?? ""}'),
                              Text('Fecha y hora: ${widget.patientData["fecha"]?.split(".").first ?? ""}',
                              ),
 
                            ],
                          ),
                        ),
                      ),

                        const SizedBox(height: 20),
                        // Bloque de Comentarios
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                            
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Comentarios',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _commentsController,
                                  maxLines: 7,
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.justify,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: ecgSignals.isEmpty
                        ? const Center(child: Text("No hay señales cargadas"))
                        : Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(ecgSignals.length, (index) {
                                      double chartHeight = 35; 
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ecgLeadsFromFile.length > index
                                                  ? ecgLeadsFromFile[index]
                                                  : 'Canal ${index + 1}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 12),
                                            ),
                                            SizedBox(
                                              height: chartHeight, // altura fija
                                              child: _buildECGChart(ecgSignals[index], index),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 130, 208, 254),
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 6,
                                            offset: Offset(2, 4),
                                          ),
                                        ],
                                        ),
                                        
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Probabilidad de Infarto Agudo de Miocardio con Elevación del Segmento ST',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,
                                              fontFamily: 'Georgia',
                                              color: Color.fromARGB(255, 0, 0, 0)),
                                              
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Estimación primaria: ${probXGBoost != null ? probXGBoost!.toStringAsFixed(2) : '--'}%       Estimación complementaria: ${probCNN != null ? probCNN!.toStringAsFixed(2) : '--'}%',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                fontFamily: 'Georgia',
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 130, 208, 254),
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 6,
                                            offset: Offset(2, 4),
                                          ),
                                        ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Localización anatómica estimada del infarto',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,fontFamily: 'Georgia'),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                            infarctLocation ?? '--',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              fontFamily: 'Georgia',
                                            ),
                                          ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 45,
              child: Row(
                children: [
                  Expanded(
                    flex: 16,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10), 
                          Align(                                  
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 110,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 130, 208, 254),
                                borderRadius: BorderRadius.circular(10),
                             
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButton<int>(
                                    value: selectedLeadIndex,
                                    hint: const Text(style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12,
                                              fontFamily: 'Roboto',color: Color.fromARGB(255, 0, 0, 0)),'Derivación'),
                                    isExpanded: true,
                                    
                                    alignment: Alignment.center,
                                    items: ecgLeadsFromFile.asMap().entries.map((entry) {
                                      final int index = entry.key;
                                      final String label = entry.value;
                                      return DropdownMenuItem<int>(
                                        value: index,
                                        child: Center(child: Text(style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12,
                                              fontFamily: 'Roboto',color: Color.fromARGB(255, 0, 0, 0)),label)),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        selectedLeadIndex = val;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),              
                        Expanded(
                          child: selectedLeadIndex != null
                              ? _buildECGChart(
                                  ecgSignals[selectedLeadIndex!],
                                  selectedLeadIndex!,
                                )
                              : const Center(
                                  child: Text('Selecciona una señal para ver en detalle'),
                                ),
                ),
              ],
            ),
          ),
        ),
      ),
                 Expanded(
  flex: 4,
  child: Align(
    alignment: Alignment.center,
    child: Row(
      children: [
        Expanded(
          child: Image.asset(
            {
              'Anterior': 'Anterior.jpg',
              'Septal': 'Septal.jpg',
              'Lateral': 'Lateral.jpg',
              'Inferior': 'Inferior.jpg',
              'Ninguna': 'Normal.jpg',
            }[infarctLocation] ?? 'Normal.jpg', 
            width: 230,
            height: 230,
            fit: BoxFit.contain,
          ),
        ),
           
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _pickAndProcessFiles,
        backgroundColor: Color.fromARGB(255, 130, 208, 254),
        child: const Icon(Icons.upload_file, size: 25),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}