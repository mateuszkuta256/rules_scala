import org.scalatest.funsuite.AnyFunSuite

class Greeting3Test extends AnyFunSuite:
  test("greeting") {
    assert(Greeting.hello == "hello3")
  }
