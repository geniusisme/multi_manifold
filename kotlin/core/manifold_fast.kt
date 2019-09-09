package geniusisme.manifold.core

fun simulate(): Pair<Int, Int> {
    var steps = 0
    while (!all_fed()) {
        step()
        steps++
    }
    return Pair(steps, steps / steps_per_second)
}

val machines_num = 1000
val steps_per_second = 2 * machines_num
val eat_at_once = 12
val eat_interval = 2 * steps_per_second
val max_space = 1200
val food_per_step = machines_num * eat_at_once * 2 / eat_interval

private enum class Dir {
    Feed,
    Away
}

val feed = 32
val away = 55

val directions = IntArray(machines_num, { away })
val buffers = IntArray(machines_num, { 0 } )
val hungers = IntArray(machines_num, { eat_interval } )
val belts = IntArray(machines_num, { 0 } )

fun step() {
    var next_belt = food_per_step
    (0 until machines_num - 1).forEach { idx ->
        var dir = directions[idx]
        val food = belts[idx]
        val split_away = if (dir == feed) food / 2 else food - food / 2
        val split_feed = food - split_away
        val leftovers = feed_machine(idx, split_feed)
        dir = if (leftovers > 0) {
            feed
        } else {
            val cmp = split_feed.compareTo(split_away)
            when {
                cmp < 0 -> feed
                cmp == 0 -> dir
                cmp > 0 -> away
                else -> throw AssertionError()
            }
        }

        directions[idx] = dir
        belts[idx] = next_belt
        next_belt = leftovers + split_away
    }
    feed_machine(machines_num - 1, belts[machines_num - 1])
    belts[machines_num - 1] = next_belt
}

fun all_fed(): Boolean {
    return hungers[machines_num - 1] < eat_interval
        && hungers[machines_num - 2] < eat_interval
        && buffers
            .take(machines_num - 2)
            .fold(true) { fed, buffer -> fed && buffer + eat_at_once >= max_space }
}

fun feed_machine(idx: Int, food: Int): Int {
    var buffer = buffers[idx]
    var hunger = hungers[idx]
    buffer = buffer + food
    hunger = hunger + 1
    val will_eat = hunger >= eat_interval && buffer >= eat_at_once
    buffer = if (will_eat) buffer - eat_at_once else buffer
    hunger = if (will_eat) 0 else hunger
    val overflow = (buffer - max_space).coerceAtLeast(0)
    buffer = buffer.coerceAtMost(max_space)
    buffers[idx] = buffer
    hungers[idx] = hunger
    return overflow
}
