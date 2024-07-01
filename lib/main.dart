import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

final dio = Dio();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Load default Demo',
      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Color(0xff004881),
          primaryContainer: Color(0xffd0e4ff),
          secondary: Color(0xffac3306),
          secondaryContainer: Color(0xffffdbcf),
          tertiary: Color(0xff006875),
          tertiaryContainer: Color(0xff95f0ff),
          appBarColor: Color(0xffffdbcf),
          error: Color(0xffb00020),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        colors: const FlexSchemeColor(
          primary: Color(0xff9fc9ff),
          primaryContainer: Color(0xff004e5d),
          secondary: Color(0xff55d6f3),
          secondaryContainer: Color(0xff004e5c),
          tertiary: Color(0xff65dca3),
          tertiaryContainer: Color(0xff005234),
          appBarColor: Color(0xff004e5c),
          error: Color(0xffcf6679),
        ),
        surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int res = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Loan Default Detector',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 15,
            ),
            const Spacer(),
            if (res == 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Safe to lend",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              )
            ] else if (res == 1) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: Theme.of(context).colorScheme.error,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Might Default",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              )
            ] else ...[
              Text(
                "Waiting for upload...",
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
            const Spacer(),
            Center(
                child: Transform.scale(
                    scale: 1.35,
                    child: FilledButton.tonalIcon(
                      icon: const Icon(Icons.upload),
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          PlatformFile file = result.files.single;
                          String url =
                              'http://localhost:8080/upload'; // Replace with the actual server URL

                          FormData formData = FormData.fromMap({
                            'file': await MultipartFile.fromBytes(file.bytes!,
                                filename: file.name),
                          });

                          try {
                            var response =
                                await Dio().post(url, data: formData);
                            print('File uploaded successfully');
                            print('Response: ${response.data}');
                            setState(() {
                              res = int.parse(response.data);
                            });
                          } catch (e) {
                            print('Error uploading the file: $e');
                          }
                        } else {
                          print('No file selected');
                        }
                      },
                      label: const Text('Upload'),
                    ))),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
