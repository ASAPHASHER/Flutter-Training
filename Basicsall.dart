import 'dart:io';

void main() {
  int age = 20;
  double height = 5.8;
  String name = "Alex";
  bool isStudent = true;

  print(age);
  print(height);
  print(name);
  print(isStudent);

  stdout.write("Enter a number: ");
  int number = int.parse(stdin.readLineSync()!);

  if (number % 2 == 0) {
    print("Even");
  } else {
    print("Odd");
  }

  for (int i = 1; i <= 5; i++) {
    print(i);
  }

  int count = 1;
  while (count <= 3) {
    print(count);
    count++;
  }

  List<int> numbers = [1, 2, 3, 4];
  numbers.add(5);
  print(numbers);

  Map<String, int> marks = {
    "Math": 90,
    "Science": 85
  };
  print(marks["Math"]);

  int result = add(5, 3);
  print(result);

  Person p = Person("John", 25);
  p.display();
}

int add(int a, int b) {
  return a + b;
}

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void display() {
    print(name);
    print(age);
  }
}
