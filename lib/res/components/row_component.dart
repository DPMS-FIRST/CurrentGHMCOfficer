

import 'package:flutter/material.dart';

class RowComponent extends StatelessWidget {
  const RowComponent({super.key, this.horizantalpadding, this.verticalpadding, this.data, this.value, this.width, this.dataflex, this.valueflex,this.color, this.fontsize, this.fontweight});
  final double? horizantalpadding;
  final double? verticalpadding;
  final String? data;
  final String? value;
  final double? width;
  final int? dataflex;
  final int? valueflex;
  final Color? color;
  final double? fontsize;
  final FontWeight? fontweight;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizantalpadding ?? 0.0,vertical: verticalpadding ?? 0.0),
      child: Row(
        children: [
          Expanded(
            flex: dataflex ?? 0,
            child: Text(data ?? '',
            style: TextStyle(
              color: color,
              fontSize: fontsize,
              fontWeight: fontweight,
            ),
            )),
          SizedBox(width: width,),
          Expanded(
            flex: valueflex ?? 0,
            child: Text(value ?? '',
            style: TextStyle(
              color: color,
              fontSize: fontsize,
              fontWeight: fontweight,
            ),
            ))
        ],
      ),
    );
  }
}