import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/getting_started/onboard.dart';
import 'package:frontend/screens/bottomnav/bottomnav_anonymous.dart';
import 'package:frontend/stylesheet/styles.dart';

class GettingStarted extends StatefulWidget {
  @override
  _GettingStartedState createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  var slides = <OnBoardModel>[];

  int currentIndex = 0;

  String message = 'Get Started';

  Widget pageIndexIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.5),
      height: 7.0,
      width: 7.0,
      decoration: BoxDecoration(
          color: isCurrentPage ? MyColors.PrimaryColor : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  void initState() {
    super.initState();
    slides = getSlides();
  }

  PageController pageController = PageController();

  void animateToNextPage(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: slides.length,
              itemBuilder: (context, index) {
                return SliderTile(
                  imageAssetPath: slides[index].getImageAssetPath(),
                  title: slides[index].title,
                  description: slides[index].description,
                );
              },
              onPageChanged: (val) {
                if (mounted)
                  setState(() {
                    currentIndex = val;
                    if (currentIndex == 0 || currentIndex == slides.length - 1)
                      message = 'Get Started';
                    else
                      message = 'Next';
                  });
              },
            ),
          ),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    currentIndex == 0
                        ? pageIndexIndicator(true)
                        : pageIndexIndicator(false),
                    currentIndex == 1
                        ? pageIndexIndicator(true)
                        : pageIndexIndicator(false),
                    currentIndex == 2
                        ? pageIndexIndicator(true)
                        : pageIndexIndicator(false),
                    currentIndex == 3
                        ? pageIndexIndicator(true)
                        : pageIndexIndicator(false)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SubmitButton(
                  text: message,
                  width: MediaQuery.of(context).size.width * 0.8,
                  onPress: () {
                    if (currentIndex != slides.length - 1) {
                      animateToNextPage(currentIndex + 1);
                    } else
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BottomNavAnonymous()));
                  },
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SliderTile extends StatelessWidget {
  final String imageAssetPath, title, description;
  SliderTile({this.imageAssetPath, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: MediaQuery.of(context).size.width / 25,
                top: MediaQuery.of(context).size.height * 0.01,
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: MyColors.PrimaryColor, width: 5.0),
                      borderRadius: BorderRadius.circular(100)),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 60,
                  ),
                ),
              ),
              ClipOval(
                  child: Image.asset(
                imageAssetPath,
                width: MediaQuery.of(context).size.width * 0.6,
              )),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: CustomPaint(
                  foregroundPainter: CirclePainter(),
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey.shade600, fontSize: 15, height: 1.5),
            ),
          )
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final circle2 = Offset((3 * size.width) / 3.7, size.height * 0.1);

    final circle3 = Offset(size.width / 4.9, size.height * 0.9);

    final circle4 = Offset((3 * size.width) / 3.8, size.height * 0.85);

    final paintOne = Paint()
      ..color = MyColors.SecondaryColor
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final paintTwo = Paint()
      ..color = MyColors.PrimaryColor
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(circle2, 20, paintOne);

    canvas.drawCircle(circle3, 10, paintOne);

    canvas.drawCircle(circle4, 3, paintTwo);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
