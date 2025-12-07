void main() {
  // Variables & Data Types
  int age = 20;
  double price = 99.99;
  String name = "Dart Learner";
  bool isActive = true;

  print("Name: $name, Age: $age, Price: $price, Active: $isActive");

  // List
  List<String> fruits = ["Apple", "Banana", "Mango"];
  fruits.add("Orange");
  print(fruits);

  // Loop
  for (var item in fruits) {
    print("Fruit: $item");
  }

  // Conditional
  if (age >= 18) {
    print("You are an adult.");
  } else {
    print("You are a minor.");
  }

  // Function call
  greet("Jack");

  // Class usage
  Person p = Person("Alice", 25);
  p.display();
}

void greet(String user) {
  print("Hello, $user!");
}

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void display() {
    print("Person Name: $name, Age: $age");
  }
}
