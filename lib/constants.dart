import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const int kVariantPoints_1 = 500;
const int kVariantPoints_2 = 500;
const int kVariantPoints_3 = 250;
const int kVariantPoints_4 = 250;

const String klogoPath = "images/UEFA_Euro_2020_Logo.webp";
const String kappBarName = "EURO PREDICTION";
const String kwelcomeScreenText = "Euro Cup \n Prediction";
const String kfirestoreSquadPath = "Squads/euro2020/";

const String kMatchVariant_1 = "MatchResult";
const String kMatchVariant_2 = "ManOfTheMatch";
const String kMatchVariant_3 = "MostGoals";
const String kMatchVariant_4 = "ScorePrediction";

const String kHeadingVariant_1 = "Result Points";
const String kHeadingVariant_2 = "MOM Points";
const String kHeadingVariant_3 = "MostGoals Points";
const String kHeadingVariant_4 = "ScorePrediction Points";
