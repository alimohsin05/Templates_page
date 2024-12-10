import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resume Builder',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: ResumeTemplatePage(),
    );
  }
}




class ResumeTemplatePage extends StatelessWidget {
  // Updated local resume templates
  final List<Map<String, String>> templates = [
    {
      "title": "ATS Classic HR Resume",
      "description": "Perfect for HR professionals with ATS-friendly design.",
      "assetPath": "assets/Resume/ATS_classic_HR_resume.docx",
      "imagePath": "assets/Images/classHR.png",
    },
    {
      "title": "Color Block Resume",
      "description": "Eye-catching design for creative professionals.",
      "assetPath": "assets/Resume/Color_block_resume.docx",
      "imagePath": "assets/Images/colorblockresume.png",
    },
    {
      "title": "Modern Florist Resume",
      "description": "Ideal for individuals in the creative or floral industries.",
      "assetPath": "assets/Resume/Modern_florist_resume.docx",
      "imagePath": "assets/Images/ModernFlorist.png",
    },
    {
      "title": "Social Media Marketing Resume",
      "description": "Tailored for marketers and social media managers.",
      "assetPath": "assets/Resume/Social_media_marketing_resume.docx",
      "imagePath": "assets/Images/SocialMediaMarketing.png",
    },
    {
      "title": "Stylish Teaching Resume",
      "description": "Designed for teachers and educators with style.",
      "assetPath": "assets/Resume/Stylish_teaching_resume.docx",
      "imagePath": "assets/Images/StylishTeaching.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Templates"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Slide To View",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.view_carousel,
                  color: Colors.teal,
                ),
              ],
            ),
          ),

          // Templates Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 25.0,
                childAspectRatio: 0.40, // Adjust aspect ratio to fit content better
              ),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Template Image
                      Expanded(
                        flex: 3, // Proportion of space for the image
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.asset(
                            template["imagePath"]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),

                      // Template Details
                      Expanded(
                        flex: 2, // Proportion of space for the details
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                template["title"]!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 2, // Limit title lines
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                template["description"]!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2, // Limit description lines
                                overflow: TextOverflow.ellipsis,
                              ),
                              Spacer(),
                              // Download Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.download_rounded, color: Colors.teal),
                                    onPressed: () async {
                                      await _downloadAndOpenFile(context, template["assetPath"]!);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "Create",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            label: "Template",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Future<void> _downloadAndOpenFile(BuildContext context, String assetPath) async {
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${assetPath.split('/').last}');

      // Copy the asset file to a temporary location
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("File downloaded to: ${file.path}"),
        duration: Duration(seconds: 3),
      ));

      // Open the file (requires a viewer app)
      await OpenFile.open(file.path);
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error downloading file: $e"),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
