import 'package:flutter/material.dart';
import './warp.dart';

class WarpData extends StatelessWidget {
  final Warp props;

  const WarpData({
    super.key,
    required this.props,
  });

  @override
  Widget build(BuildContext context) {
    return Row (
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Text(
              props.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        VerticalDivider(thickness: 0.3,),
        Expanded(
          child: Center(
            child: Text(
              '${props.rankType}*',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        VerticalDivider(thickness: 1,),
        Expanded(
          child: Center(
            child: Text(
              props.time,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        VerticalDivider(thickness: 1,),
        Expanded(
          child: Center(
            child: Text(
              props.itemType,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}