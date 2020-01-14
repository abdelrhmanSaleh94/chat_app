import 'package:flutter/material.dart';

class ButtonDetials extends StatelessWidget {
  final String title;
  final Color colorIcon;
  final IconData icon;
  final Function onTap;
  final Color colorButton;
  final Color titleColor; 
  ButtonDetials(
      {@required this.title,
      @required this.icon,
      @required this.colorIcon,
      @required this.onTap,
      @required this.colorButton,
      @required this.titleColor
      });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorButton,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          margin: EdgeInsets.all(5),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: titleColor,
                  textBaseline: TextBaseline.alphabetic,
                  fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
