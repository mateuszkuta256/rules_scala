import org.scalatest.funsuite.AnyFunSuite

class Greeting2Test extends AnyFunSuite {
  test("greeting") {
    assert(Greeting.hello == "hello2")
  }
}
