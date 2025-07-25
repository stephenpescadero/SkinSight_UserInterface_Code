import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final GlobalKey _camerabutton = GlobalKey();
final GlobalKey _gallerybutton = GlobalKey();

class _HomeState extends State<Home> {
  final picker = ImagePicker();
  File ? _image;
  List<String> confidence = ['', '', ''];
  List<int> index = [999, 999, 999];
  List<String> label = ['', '', ''];
  List<bool> button = [false, false, false];
  bool infoButton = false;

  List<String> descriptions = [
    'Acne is a skin condition that occurs when hair follicles become clogged with oil and dead skin cells. It is most common among teenagers, though it affects people of all ages. Acne typically appears on the face, forehead, chest, upper back, and shoulders because these areas have the most oil (sebaceous) glands.',
    'Actinic keratosis is a rough, scaly patch or bump on the skin. It is also known as solar keratosis. Typically, these patches appear on sun-exposed areas like the face, ears, and hands, and they may itch or feel prickly.',
    'Noncancerous growths in the body are referred to as benign tumors. These tumors have distinct borders, grow slowly, and can appear anywhere in the body.',
    'Candidiasis is a fungal skin infection that causes a red, itchy rash, usually in the skin folds. Cutaneous candidiasis occurs when the skin becomes infected with Candida. Candida fungi thrive and proliferate in warm, moist environments, which is why the condition frequently affects areas with skin folds.',
    'Eczema is a skin disorder that causes dryness, itching, and bumps, and reduces the ability of the skin to retain moisture and protect against external factors. This common, non-contagious condition may flare up when triggered by irritants or allergens, and symptoms can vary based on an individual’s skin tone. For those with dark skin, eczema rashes may appear purple, brown, or gray, while those with light skin may experience pink, red, or purple rashes. Symptoms include dry, itchy skin, skin rashes, bumps, thick patches, flaky or crusty skin, and swelling. Various factors, including genetics, the immune system, environmental triggers, and emotional stress, contribute to eczema.',
    'Leprosy, also known as Hansen’s disease, is an ancient chronic infectious disease that remains a major global health concern, affecting over 200,000 people each year, particularly in resource-limited and disadvantaged populations in underdeveloped countries. Caused by the slow-growing bacterium Mycobacterium leprae, leprosy leads to nerve damage and permanent disabilities, including blindness and paralysis.',
    'Rosacea is a common skin condition that causes flushing or long-term redness on the face. It may also lead to enlarged blood vessels and small, pus-filled bumps. Symptoms can flare up for weeks to months and then subside for a while. Rosacea can sometimes be mistaken for acne, dermatitis, or other skin issues. If left untreated, it can worsen over time and lead to disfiguring effects, such as rhinophyma (thickening of the skin). While the exact cause of rosacea is unclear, it is linked to factors like sun exposure, stress, and certain foods.',
    'Skin cancer is classified as nonmelanoma skin cancer (NMSC) or melanoma, with UV radiation exposure being the primary cause. The incidence of skin cancer is rising, with basal cell carcinoma (BCC) and squamous cell carcinoma (SCC) being the most commonly diagnosed types. Risk factors include fair skin, prolonged sun exposure, and genetics.',
    'Vitiligo is a skin disorder that causes the loss of pigmentation, resulting in white or lighter patches of skin. Patches are areas greater than 1 centimeter in diameter, while smaller areas are called macules. If vitiligo affects hair, it may turn white or silver. The condition occurs when the body’s immune system attacks and destroys melanocytes, the cells responsible for producing melanin, the pigment that gives skin its color.',
    'Warts, caused by the human papillomavirus (HPV), are small growths that can appear anywhere on the body, often as firm lumps, flat circular patches, or thread-like protrusions. These growths occur due to the rapid growth of keratin, a protein in the top layer of the skin, triggered by various strains of HPV. HPV is spread through skin-to-skin contact or by coming into contact with contaminated objects.'
  ];

  List<String> recommendations = [
    '- Retinoids and retinoid-like drugs, antibiotics, azelaic acid, salicylic acid, and dapsone.\n- Topical benzoyl peroxide, adapalene and tretinoin are effective in preadolescent children.\n- Clearasil.\n- Stridex.\n- PanOxyl.\n- Retin-A.\n- Tazorac.\n- Differin.\n- Aczone.\n',
    '- Cryotherapy.\n- Topical chemotherapy.\n- Laser surgery.\n- Liquid nitrogen, shave excision, curettage, electrocautery.\n- Urea cream, salicylic acid ointment, or topical retinoids.\n',
    '- Laboratory testing.\n- Removal.\n- Physical examinations, biopsies.\n- Imaging tests (CT scans, MRIs, or ultrasounds).\n- X-rays.\n',
    '- Regularly changing the infant’s diaper and allowing them to wear loose-fitting garments over the diaper.\n- Home remedies.\n- Maintaining good hygiene.\n- Antifungal cream or powder.\n- Using or taking an antifungal medication, either oral (pill, lozenge, or liquid) or topical (cream or ointment).\n- Maintaining good physical and oral hygiene.\n',
    '- Use moderate or sensitive skin moisturizers throughout the day.\n- Apply topical drugs to the skin as directed by a clinician (such as topical steroids).\n- To relieve irritation and swelling, take oral treatments such as anti-inflammatory drugs, antihistamines, or corticosteroids, immunosuppressant medications help to modify how your immune system work.\n',
    '- Vitamin D, vitamin D receptors (VDR), and the skin biopsies can help ease the leprosy.\n- Treatment regimen consists of three drugs: dapsone, rifampicin, and clofazimine (Multi-Drug Therapy Combination).\n',
    '- Avoiding triggers.\n- Using gentle skincare.\n- Antibiotics or topical creams.\n- Metronidazole or azelaic acid.\n- Oral antibiotics.\n',
    '- Regular screenings.\n- Broad-spectrum sunscreen.\n- Cryosurgery: Freezes cancer cells with liquid nitrogen.\n- Excisional surgery: Removes tumor and surrounding skin.\n- Mohs surgery: Removes thin layers of cancerous tissue.\n- Curettage and electrodesiccation: Scrapes and destroys cancer cells.\n- Radiation therapy: Uses high-energy beams to kill cancer cells.\n- Chemotherapy: Kills cancer cells with drugs.\n- Photodynamic therapy: Uses light to destroy cancer cells.\n- Biological therapy: Boosts immune system to fight cancer.\n- Diagnosis: Physical exam and skin sample analysis.\n- Sunscreen: Prevents skin cancer by blocking UV rays.\n- Regular skin examinations for early detection, and policy initiatives to reduce UV exposure.\n',
    '- Corticosteroids.\n- Calcineurin inhibitors.\n- JAK inhibitors to reduce inflammation and repigment skin, Narrowband UVB or PUVA therapy to stimulate pigment production.\n- For widespread vitiligo, removing remaining pigment for uniform skin tone. Skin grafting or melanocyte transplantation for stable vitiligo.\n',
    '- Topical treatments, surgery, or antibiotics.\n- For speedier treatment use salicylic acid application, cryotherapy, laser treatment, immunotherapy, electrosurgery, and excision.\n- Immunotherapy (has emerged as one of the most important treatments for warts). Examples of systemic immunotherapeutic techniques are echinacea, propolis, oral retinoids, glycyrrhizinic acid, levamisole, cimetidine, and zinc sulfate.\n'
  ];

  Future<void> loadModel() async {
    debugPrint("Running Load Model...");
    await Tflite.loadModel(
      model: "assets/models/skinsight.tflite",
      labels: "assets/labels/skinsight.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );

    debugPrint("Model loaded successfully!");
  }

  Future<File> resizeImage(File imageFile) async {
    // Read image as bytes
    Uint8List imageBytes = await imageFile.readAsBytes();

    // Decode image
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) return imageFile;

    // Create a new image without the alpha channel (RGB)
    img.Image rgbImage = img.Image(image.width, image.height);
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        // Extract RGB values (ignoring alpha)
        int pixel = image.getPixel(x, y);
        int r = img.getRed(pixel);
        int g = img.getGreen(pixel);
        int b = img.getBlue(pixel);
        rgbImage.setPixelRgba(x, y, r, g, b);  // No alpha channel
      }
    }

    // Maintain aspect ratio by cropping the center
    int minSide = image.width < image.height ? image.width : image.height;
    img.Image cropped = img.copyCrop(rgbImage,
      (image.width - minSide) ~/ 2,
      (image.height - minSide) ~/ 2,
      minSide,
      minSide,
    );

    // Resize to 224x224
    img.Image resized = img.copyResize(cropped, width: 224, height: 224);

    // Save the processed image
    File resizedFile = File(imageFile.path)..writeAsBytesSync(img.encodeJpg(resized));
    return resizedFile;
  }

  Future pickImage() async {
    final image = await picker.pickImage(source: ImageSource.camera);
    if(image == null) return;

    File originalImage = File(image.path);
    File resizedImage = await resizeImage(originalImage); // Resize it first

    setState(() {
      label = ['', '', ''];
      confidence = ['', '', ''];
      index = [999, 999, 999];
      button = [false, false, false];
      _image = File(image.path);
    });

    var recognitions = await Tflite.runModelOnImage(
        path: resizedImage.path,
        imageMean: -1,
        imageStd: 1,
        numResults: 10,
        threshold: 0.2,
        asynch: true
    );

    if (recognitions == null) {
      devtools.log("recognitions is Null");
      return;
    }
    devtools.log(recognitions.toString());
    for (var i =0; i < 3; i++) {
      setState(() {
        confidence[i] = (recognitions[i]['confidence'] * 100).toStringAsFixed(2);
        index[i] = recognitions[i]['index'];
        label[i] = recognitions[i]['label'].toString();
      });
    }
  }

  Future pickGalleryImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if(image == null) return;

    File originalImage = File(image.path);
    File resizedImage = await resizeImage(originalImage); // Resize it first

    setState(() {
      label = ['', '', ''];
      confidence = ['', '', ''];
      index = [999, 999, 999];
      button = [false, false, false];
      _image = File(image.path);
    });

    var recognitions = await Tflite.runModelOnImage(
        path: resizedImage.path, // required
        imageMean: -1, // defaults to 117.0
        imageStd: 1, // defaults to 1.0
        numResults: 10, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
    );

    if (recognitions == null) {
      devtools.log("recognitions is Null");
      return;
    }
    devtools.log(recognitions.toString());
    for (var i =0; i < 3; i++) {
      setState(() {
        confidence[i] = (recognitions[i]['confidence'] * 100).toStringAsFixed(2);
        index[i] = recognitions[i]['index'];
        label[i] = recognitions[i]['label'].toString();
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Tflite.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
    _createTutorial(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/skinsightlogo.png',
            fit: BoxFit.contain,
            height: 32,
          ),

          Container(
              padding: const EdgeInsets.all(8.0), child: Text('SkinSight: Skin Disease Detector', style: TextStyle(color: Color(0xff0e0217),
              fontWeight: FontWeight.bold,
              fontSize: 18)))
        ],
      ),
        backgroundColor: Color(0xFFFFA15B),
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 2,),
              Text('Disclaimer: This application may not be a substitute for professional diagnosis. If symptoms persist please consult your dermatologist.', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              SizedBox(height: 2,),
              Card(
                elevation: 10,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 350,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Color(0x00000000),
                            borderRadius: BorderRadius.circular(12.0),
                            image: const DecorationImage(image: AssetImage('assets/skinsightlogo.png')
                            )
                          ),
                          child: _image == null ? const Text('') : Image.file(_image!, fit: BoxFit.fill),
                        ),



                        (index[0] <= 10 && double.parse(confidence[0]) >= 40.0) ? Padding( padding: const EdgeInsets.all(0),
                          child: Column(
                            children: [
                              (index[0] <= 10) ? Padding( padding: const EdgeInsets.all(0),
                                child: Column(
                                  children: [SizedBox(height: 10,),
                                    ElevatedButton(onPressed: () => setState(() => button[0] = !button[0]),
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),),
                                    foregroundColor: Colors.black,
                                    shadowColor: Colors.redAccent
                                ),
                                child: Column(
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(text: 'Prediction 1 - ', style: TextStyle(fontSize: 16)),
                                          TextSpan(text: label[0], style: TextStyle(fontSize: 16)),
                                          TextSpan(text: ': ', style: TextStyle(fontSize: 16)),
                                          TextSpan(text: confidence[0], style: TextStyle(fontSize: 16)),
                                          TextSpan(text: '%', style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    textAlign: TextAlign.center,)
                                  ]
                                ),
                              ),
                              Visibility(visible: button[0],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Divider(color: Colors.blueGrey,),
                                            Text('Descriptions:', style: TextStyle(fontWeight: FontWeight.bold),),
                                            Text(descriptions[index[0]]),
                                            Divider(color: Colors.blueGrey,),
                                            Text('Recommendations:', style: TextStyle(fontWeight: FontWeight.bold,),),
                                            Text(recommendations[index[0]]),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                              ])) : Padding(padding:const EdgeInsets.all(0)),



                              (index[1] <= 10) ? Padding( padding: const EdgeInsets.all(0),
                                child: Column(
                                  children: [SizedBox(height: 10,),
                                    ElevatedButton(onPressed: () => setState(() => button[1] = !button[1]),
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),),
                                    foregroundColor: Colors.black,
                                    shadowColor: Colors.redAccent
                                ),
                                child: Column(
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(text: 'Prediction 2 - ', style: TextStyle(fontSize: 16)),
                                            TextSpan(text: label[1], style: TextStyle(fontSize: 16)),
                                            TextSpan(text: ': ', style: TextStyle(fontSize: 16)),
                                            TextSpan(text: confidence[1], style: TextStyle(fontSize: 16)),
                                            TextSpan(text: '%', style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,)
                                    ]
                                ),
                              ),
                              Visibility(visible: button[1],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Divider(color: Colors.blueGrey,),
                                            Text('Descriptions:', style: TextStyle(fontWeight: FontWeight.bold),),
                                            Text(descriptions[index[1]]),
                                            Divider(color: Colors.blueGrey,),
                                            Text('Recommendations:', style: TextStyle(fontWeight: FontWeight.bold,),),
                                            Text(recommendations[index[1]]),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                              ])) : Padding(padding:const EdgeInsets.all(0)),



                              (index[2] <= 10) ? Padding( padding: const EdgeInsets.all(0),
                                child: Column(
                                  children: [SizedBox(height: 10,),
                                    ElevatedButton(onPressed: () => setState(() => button[2] = !button[2]),
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),),
                                    foregroundColor: Colors.black,
                                    shadowColor: Colors.redAccent
                                ),
                                child: Column(
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(text: 'Prediction 3 - ', style: TextStyle(fontSize: 16)),
                                            TextSpan(text: label[2], style: TextStyle(fontSize: 16)),
                                            TextSpan(text: ': ', style: TextStyle(fontSize: 16)),
                                            TextSpan(text: confidence[2], style: TextStyle(fontSize: 16)),
                                            TextSpan(text: '%', style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,)
                                    ]
                                ),
                              ),
                              Visibility(visible: button[2],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Divider(color: Colors.blueGrey,),
                                            Text('Descriptions:', style: TextStyle(fontWeight: FontWeight.bold),),
                                            Text(descriptions[index[2]]),
                                            Divider(color: Colors.blueGrey,),
                                            Text('Recommendations:', style: TextStyle(fontWeight: FontWeight.bold,),),
                                            Text(recommendations[index[2]]),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                                    ])) : Padding(padding:const EdgeInsets.all(0)),


                            ],
                          ),
                        ) : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 3.0),
                            child: Column(
                              children: [
                                (index[0] <= 10 && double.parse(confidence[0]) < 40.0) ? Text('INVALID IMAGE', style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
                                    : Text(''),
                                Text('How to Use:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                Text('1) Take a picture of the skin lesion or choose an image from your gallery.', style: TextStyle(fontSize: 13)),
                                Text('2) Make sure the lesion is well within view and is visible.', style: TextStyle(fontSize: 13)),
                                Text('3) Click on the predictions to show descriptions and recommendations for the predicted diseases.', style: TextStyle(fontSize: 13)),
                              ],
                            )
                        ),

                        SizedBox(height: 10,)
                      ],),
                  ),
                )
              ),
              const SizedBox(
                height: 10,
              ),

              ElevatedButton(key: _camerabutton, onPressed: (){
                pickImage();
              },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 45, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),),
                    foregroundColor: Colors.black,
                    shadowColor: Colors.redAccent
                  ),
                child: const Text("Take a Picture", style: TextStyle(fontSize: 18),),
              ),
              SizedBox(height: 10,),
              ElevatedButton(key: _gallerybutton, onPressed: (){
                pickGalleryImage();
              },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),),
                    foregroundColor: Colors.black,
                  shadowColor: Colors.redAccent
                ),
                child: const Text("Choose from Gallery", style: TextStyle(fontSize: 18),),
              ),
              SizedBox(height: 30,),
              Align(
                alignment: Alignment(0.93, 0.93),
                child: IconButton(
                  icon: Icon(Icons.info),
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      infoButton = !infoButton;
                    });
                  },
                )
              ),
              Visibility(visible: infoButton,
                child: Card(
                  elevation: 5,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: 350,
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 3.0),
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Text('SkinSight: AI-Powered Application for Skin Disease Detection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

                            SizedBox(height: 10,),
                            Text('SkinSight aims to develop an affordable and accessible AI-powered application designed to detect various skin diseases. This innovation is specifically created to assist individuals who may face financial challenges in accessing medical care. By providing accurate and reliable results, our project seeks to reduce costs, save time, and improve the quality of life for those affected by skin conditions.\n', style: TextStyle(fontSize: 15), textAlign: TextAlign.justify,),
                            Text('Currently, SkinSight can detect the following skin diseases: \n- Acne\n- Actinic Keratoses\n- Benign Tumors\n- Candidiasis\n- Eczema\n- Leprosy\n- Rosacea\n- Skin Cancer\n- Vitiligo\n- Warts\n', style: TextStyle(fontSize: 15), textAlign: TextAlign.justify,),
                            SizedBox(height: 30,),
                            Divider(color: Colors.blueGrey,),
                            SizedBox(height: 45,),
                            Text('The Team Behind SkinSight!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                            Text('Salimbangon, Shara C.', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                            Text('Pescadero, Stephen John L.', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                            Text('Gumahad, Mariegine A.', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                            Text('Alvarez, Dane Ian P.', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                            Text('Bayubay, Jayr E.', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                            Text('Briones, Kelsey P.', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                            Text('Contiberos, Karl David B.', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                            Text('Getalla, Mikhail Renier T.', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                            Text('Limbaga, Harvey O.', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                            SizedBox(height: 45,),
                            Divider(color: Colors.blueGrey,),
                            SizedBox(height: 30,),
                            Text('Sources for the descriptions:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                            Text('• https://www.mayoclinic.org/diseases-conditions//diagnosis-treatment/drc-20368048', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://www.hopkinsmedicine.org/health/conditions-and-diseases/actinic-keratosis', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://www.healthline.com/health/benign#see-your-doctor', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://www.healthline.com/health//-#symptoms', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://my.clevelandclinic.org/health/diseases/9998-eczema ', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://link.springer.com/chapter/10.1007/978-3-031-24355-4_3', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://www.mayoclinic.org/diseases-conditions/rosacea/symptoms-causes/syc-20353815', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://pubmed.ncbi.nlm.nih.gov/28722978/       ', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://my.clevelandclinic.org/health/diseases/12419-vitiligo', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://www.medicalnewstoday.com/articles/155039#_noHeaderPrefixedContent', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            SizedBox(height: 20,),
                            Text('Sources for the recommendations:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                            Text('• https://www.mayoclinic.org/diseases-conditions/acne/diagnosis-treatment/drc-20368048\n• https://my.clevelandclinic.org/health/diseases/12233-acne#management-and-treatment', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://www.hopkinsmedicine.org/health/conditions-and-diseases/actinic-keratosis\n• https://dermnetnz.org/topics/actinic-keratosis', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://www.healthline.com/health/benign#see-your-doctor\n• https://my.clevelandclinic.org/health/diseases/22121-benign-tumor', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://www.healthline.com/health/skin/cutaneous-candidiasis#symptoms\n• https://my.clevelandclinic.org/health/diseases/23198-candidiasis', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://www.mayoclinic.org/diseases-conditions/rosacea/symptoms-causes/syc-20353815\n• https://my.clevelandclinic.org/health/diseases/12174-rosacea', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://www.ncbi.nlm.nih.gov/books/NBK441949/\n• https://pmc.ncbi.nlm.nih.gov/articles/PMC8362234/', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            Text('• https://my.clevelandclinic.org/health/diseases/12419-vitiligo#management-and-treatment', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),

                            SizedBox(height: 20,),
                          ],
                        )
                        )
                    )
                  ),
              ),
              SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }
}

  Future<void> _createTutorial(BuildContext context) async {
    final targets = [
    TargetFocus(
        shape: ShapeLightFocus.RRect,
        identify: "Camera Button",
        keyTarget: _camerabutton,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: Text("Use this button to capture images with your camera.",
                      style: TextStyle(
                          color: Colors.white, fontSize: 25
                      ),textAlign: TextAlign.center,),
                  )
                ],
              )
          )
        ]
    ),
      TargetFocus(
          shape: ShapeLightFocus.RRect,
          identify: "Gallery Button",
          keyTarget: _gallerybutton,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      child: Text("Use this button to choose images from your gallery.",
                        style: TextStyle(
                            color: Colors.white, fontSize: 25
                        ),textAlign: TextAlign.center,),
                    )
                  ],
                )
            )
          ]
      ),
    ];
    final tutorial = TutorialCoachMark(
    targets: targets,
      onClickOverlay: (target){}
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      tutorial.show(context: context);
    });
  }
