import 'package:flutter/material.dart';
import 'package:nightview/constants/values.dart';
import 'package:searchfield/searchfield.dart';

const kMainInputDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
      width: kMainStrokeWidth,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
      width: kFocussedStrokeWidth,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
      width: kMainStrokeWidth,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
      width: kFocussedStrokeWidth,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
);

SearchInputDecoration kSearchInputDecoration = SearchInputDecoration(
  border: InputBorder.none
);


