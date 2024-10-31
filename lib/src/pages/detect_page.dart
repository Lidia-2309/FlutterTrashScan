import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class DetectPage extends StatefulWidget {
  const DetectPage({super.key});

  @override
  _DetectPageState createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> {
  File? image;
  late List _results;
  bool imageSelect = false;
  // Interpreter? interpreter;

  @override
  void initState() {
    super.initState();
    // loadModel();
  }

  // Future<void> loadModel() async {
  //   Tflite.close();
  //   String res;
  //   res = (await Tflite.loadModel(model: 'lib/src/assets/best_float32.tflite', labels: 'lib/src/assets/labels.txt'))!;
  //   print("Models loading status: $res");
  // }

  // Future<void> imageDetection (File image)
  // async {
  //   var recognitions = await Tflite.runModelOnImage(
  //     path: image.path,   // required
  //     numResults: 6,    // defaults to 5
  //     threshold: 0.5,   // defaults to 0.1
  //     imageMean: 127.5,   // defaults to 117.0
  //     imageStd: 127.5,  // defaults to 1.0
  //   );
  //   setState(() {
  //     _results=recognitions!;
  //     image = image;
  //     imageSelect = true;

  //   });
  // }


  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future takePhoto() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      print('Path da imagem: ${image.path}');
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to take photo: $e');
    }
  }

  void removeImage() {
    setState(() => image = null);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 230, 230, 230),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        title: Row(
          children: [
            BackButton(
              onPressed: () => {context.go('/')},
              color: const Color.fromARGB(255, 103, 143, 124),
            ),
            const SizedBox(width: 8),
            Text(
              'Detector de Resíduos',
              style: TextStyle(
                color: const Color.fromARGB(255, 103, 143, 124),
                fontSize: height * 0.023,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: width * 0.9,
          height: height * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 216, 216, 216),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: image == null ? pickImage : null,
                child: Stack(
                  children: [
                    DottedBorder(
                      color: const Color(0xFF678F7C),
                      strokeWidth: 1,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [6, 3],
                      child: Container(
                        width: width * 0.7,
                        height: height * 0.30,
                        padding: const EdgeInsets.all(15),
                        child: Center(
                          child: image == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 30,
                                      color: const Color(0xFF678F7C),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Clique aqui para navegar pelos arquivos',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Extensões Suportadas: PNG, JPG, JPEG, WEBP',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    if (image != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: removeImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF678F7C),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              imageSelect ?
                Expanded(
                  child: ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${_results[index]['label']} - ${( _results[index]['confidence'] * 100).toStringAsFixed(2)}%",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              :
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 0.7,
                      ),
                    ),
                  ),
                  const Text(
                    'ou',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              SizedBox(
                width: width * 0.4,
                child: ElevatedButton.icon(
                  onPressed: takePhoto,
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Tirar Foto',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF678F7C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(top: height * 0.03),
                child: SizedBox(
                  width: width * 0.6,
                  child: ElevatedButton.icon(
                    onPressed: ()=>{
                      
                    },
                    // onPressed: image != null ? () => imageDetection(image!) : null,
                    //icon: const Icon(Icons.document_scanner, color: Colors.white),
                    label: const Text(
                      'Detectar',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06502D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
