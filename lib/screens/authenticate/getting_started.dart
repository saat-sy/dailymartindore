import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/getting_started/onboard.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:frontend/stylesheet/styles.dart';

class GettingStarted extends StatefulWidget {
  @override
  _GettingStartedState createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  List<OnBoardModel> slides = new List<OnBoardModel>();

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
    pageController.animateToPage(index, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
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
              setState(() {
                currentIndex = val;
                if (currentIndex == 0 || currentIndex == slides.length - 1)
                  message = 'Get Started';
                else
                  message = 'Skip';
              });
            },
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
                  height: 35,
                ),
                
                SubmitButton(
                  text: message,
                  width: MediaQuery.of(context).size.width * 0.8,
                  onPress: () {
                    if (currentIndex != slides.length - 1) {
                      animateToNextPage(currentIndex + 1);
                    }
                    else
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BottomNav()));
                  },
                ),
                
                SizedBox(
                  height: 25,
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
  String imageAssetPath, title, description;
  SliderTile({this.imageAssetPath, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 100,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              ClipOval(
                  child: Image.asset(
                imageAssetPath,
                width: MediaQuery.of(context).size.width * 0.7,
              )),
              Container(
                height: MediaQuery.of(context).size.width * 0.7,
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
            width: MediaQuery.of(context).size.width * 0.69,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
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
    final circle1 = Offset(size.width / 6.5, size.height * 0.2);

    final circle2 = Offset((3 * size.width) / 3.6, size.height * 0.1);

    final circle3 = Offset(size.width / 5, size.height * 0.9);

    final circle4 = Offset((3 * size.width) / 3.7, size.height * 0.85);

    final paint = Paint()
      ..color = MyColors.SecondaryColor
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(circle1, 15, paint);

    canvas.drawCircle(circle2, 23, paint);

    canvas.drawCircle(circle3, 10, paint);

    canvas.drawCircle(circle4, 3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
