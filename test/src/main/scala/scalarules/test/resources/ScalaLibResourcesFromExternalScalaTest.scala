package scalarules.test.resources

import org.scalatest.funsuite._

class ScalaLibResourcesFromExternalScalaTest extends AnyFunSuite {

  test("Scala library depending on resources from external resource-only jar should allow to load resources") {
    val expectedString = String.format("A resource");
    assert(get("resource.txt") === expectedString)
  }

  private def get(s: String): String =
    List("/external/test_new_local_repo/", "/external/_main~non_module_deps~test_new_local_repo/")
      .map(p => Option(getClass.getResourceAsStream(p + s)))
      .find(_.isDefined)
      .map(s => scala.io.Source.fromInputStream(s.get))
      .map(_.mkString)
      .get

}
