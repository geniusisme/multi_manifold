package geniusisme.manifold.jvm
import geniusisme.manifold.core.*

fun main(args: Array<String>) {
    val (steps, secs) = simulate()
    println("secs: $secs, steps: $steps")
}
