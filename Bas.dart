import 'dart:io';

// A simple class
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print("Hi! I'm $name and I'm $age years old.");
  }
}

void main() {
  // ----- Variables -----
  int number = 10;
  double pi = 3.14;
  bool isLearning = true;
  String language = "Dart";

  print("Number: $number");
  print("Pi value: $pi");
  print("Learning Dart? $isLearning");
  print("Language: $language");

  // ----- List -----
  List<String> fruits = ["Apple", "Banana", "Orange"];
  print("Fruits: $fruits");

  // ----- Conditional -----
  if (number > 5) {
    print("Number is greater than 5");
  } else {
    print("Number is 5 or less");
  }

  // ----- Loop -----
  print("Looping through fruits:");
  for (var fruit in fruits) {
    print("- $fruit");
  }

  // ----- Input -----
  stdout.write("Enter your name: ");
  String? name = stdin.readLineSync();

  stdout.write("Enter your age: ");
  int? age = int.parse(stdin.readLineSync()!);

  // ----- Using the class -----
  Person p = Person(name ?? "Unknown", age);
  p.introduce();
}
