class Polymorphism {

  static class Hello {

    void speak() {
      System.out.println("Hello World!");
    }
  }

  static class Goodbye extends Hello {

    void speak() {
      System.out.println("Goodbye!");
    }
  }

  public static void main(String [] args) {

    Hello hello = new Hello();
    Hello goodbye = new Goodbye();

    hello.speak();    //=> Hello World!
    goodbye.speak();  //=> Goodbye!
  }
}
