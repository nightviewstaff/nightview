import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';
import 'package:searchfield/searchfield.dart';

const kMainInputDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: white,
      width: kMainStrokeWidth,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(kNormalSizeRadius),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: white,
      width: kFocussedStrokeWidth,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(kNormalSizeRadius),
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: redAccent,
      width: kMainStrokeWidth,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(kNormalSizeRadius),
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: redAccent,
      width: kFocussedStrokeWidth,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(kNormalSizeRadius),
    ),
  ),
);

SearchInputDecoration kSearchInputDecoration = SearchInputDecoration(
  border: InputBorder.none
);


