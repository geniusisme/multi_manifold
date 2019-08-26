use Dir::*;

fn main() {
    let cfg = get_config();
    let mut s = Simulation {
        machines: vec![Machine { food: 0, hunger: cfg.eat_interval }; cfg.machines_num],
        directions: vec![Away; cfg.machines_num],
        foods: vec![0; cfg.machines_num],
        config: cfg,
        steps: 0,
    };

    while s.step() {}
    println!("Hello, world! steps: {}, time: {}", s.steps, s.steps / s.config.steps_per_second);
    //dbg!("Hello, world! {}", s.foods);
    //dbg!(s.machines);
}

#[derive(Copy, Clone, Debug)]
struct Machine {
    food: i64,
    hunger: i64,
}

#[derive(Copy, Clone, Debug)]
enum Dir {
    Feed,
    Away,
}

fn odd(i: i64) -> bool {
    i % 2 == 1
}

#[derive(Debug)]
struct Simulation {
    machines: Vec<Machine>,
    directions: Vec<Dir>,
    foods: Vec<i64>,
    config: Config,
    steps: i64,
}

#[derive(Debug)]
struct Config {
    steps_per_second: i64,
    eat_interval: i64,
    max_space: i64,
    eat_at_once: i64,
    food_per_step: i64,
    machines_num: usize,
}

fn get_config() -> Config {
    let machines_num = 1000;
    let steps_per_second = 2 * machines_num;
    let eat_at_once = 12;
    let eat_interval = 2 * steps_per_second;
    let max_space = 1200;
    let food_per_step = machines_num * eat_at_once * 2 / eat_interval;
    Config {
        steps_per_second,
        eat_interval,
        max_space,
        eat_at_once,
        food_per_step,
        machines_num: (machines_num as usize),
    }
}

impl Simulation {

    fn step(&mut self) -> bool {
        //dbg!("=========================================");
        //dbg!(&self.foods);
        //dbg!(&self.machines);

        self.steps = self.steps + 1;
        let config = &self.config;
        let len = self.machines.len();

        let last_food = self.machines.iter_mut().zip(self.directions.iter_mut()).zip(self.foods.iter_mut())
            .take(len - 1)
            .scan(config.food_per_step, |next_step_food, ((machine, dir), food)| {
                let (fed, dr) = match (*dir, *food){
                    (d, 0) => (0, d),
                    (Feed, f) if odd(f) => (f/2 + 1, Away),
                    (Feed, f) => (f/2, Feed),
                    (Away, f) if odd(f) => (f/2, Feed),
                    (Away, f) => (f/2, Away),
                };
                let leftovers = feed_machine(config, machine, fed);
                *dir = if leftovers > 0 { Feed } else { dr };
                let through = *food - fed + leftovers;
                *food = *next_step_food;
                *next_step_food = through;
                Some(*next_step_food)
            })
            .last().unwrap();

        feed_machine(config, &mut self.machines[len - 1], self.foods[len - 1]);
        self.foods[len - 1] = last_food;

        !self.all_fed()
        //self.machines[len - 3].food != config.max_space
    }

    fn all_fed(&self) -> bool {
        let len = self.machines.len();
        self.machines[len - 1].hunger < self.config.eat_interval
            && self.machines[len - 2].hunger < self.config.eat_interval
            && self.machines.iter()
                .take(len - 2)
                .fold(true, |f, m| f && m.food + self.config.eat_at_once >= self.config.max_space)
    }
}

fn feed_machine(config: &Config, machine: &mut Machine, food: i64) -> i64 {
    machine.food += food;
    if machine.hunger + 1 >= config.eat_interval && machine.food >= config.eat_at_once {
        machine.food -= config.eat_at_once;
        machine.hunger = 0;
    } else {
        machine.hunger += 1;
    }
    if machine.food > config.max_space {
        let excess = machine.food - config.max_space;
        machine.food = config.max_space;
        excess
    } else {
        0
    }
}
