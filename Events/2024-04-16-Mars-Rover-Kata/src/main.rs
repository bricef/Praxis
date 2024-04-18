#![allow(dead_code)]

use std::fmt::Write;

fn main() {
    println!("Hello, world!");
}

enum Command {
    Left,
    Right,
    Forward,
    Back,
}
#[derive(PartialEq, Eq, Copy, Clone)]
enum Heading {
    North,
    East,
    South,
    West,
}

impl std::fmt::Display for Heading {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Heading::North => f.write_char('N'),
            Heading::East => f.write_char('E'),
            Heading::South => f.write_char('S'),
            Heading::West => f.write_char('W'),
        }
    }
}

fn rotate_left(heading: Heading) -> Heading {
    match heading {
        Heading::North => Heading::West,
        Heading::West => Heading::South,
        Heading::South => Heading::East,
        Heading::East => Heading::North,
    }
}
fn rotate_right(heading: Heading) -> Heading {
    match heading {
        Heading::North => Heading::East,
        Heading::East => Heading::South,
        Heading::South => Heading::West,
        Heading::West => Heading::North,
    }
}

fn wrap(value: i32) -> i32 {
    if value < 0 {
        9
    } else if value > 9 {
        0
    } else {
        value
    }
}

struct Rover {
    heading: Heading,
    x: i32,
    y: i32,
}
impl Rover {
    fn default() -> Rover {
        Rover {
            x: 0,
            y: 0,
            heading: Heading::North,
        }
    }
    fn new(heading: Heading, x: i32, y: i32) -> Rover {
        Rover { x, y, heading }
    }
    fn position(&self) -> String {
        format!("{}:{}:{}", self.heading, self.x, self.y)
    }
    fn forward(&mut self) {
        match self.heading {
            Heading::North => self.y += 1,
            Heading::East => self.x += 1,
            Heading::South => self.y -= 1,
            Heading::West => self.x -= 1,
        }
        self.x = wrap(self.x);
        self.y = wrap(self.y);
    }
    fn backward(&mut self) {
        match self.heading {
            Heading::North => self.y -= 1,
            Heading::East => self.x -= 1,
            Heading::South => self.y += 1,
            Heading::West => self.x += 1,
        }
        self.x = wrap(self.x);
        self.y = wrap(self.y);
    }
    fn send(&mut self, command: Command) {
        match command {
            Command::Left => self.heading = rotate_left(self.heading),
            Command::Right => self.heading = rotate_right(self.heading),
            Command::Forward => self.forward(),
            Command::Back => self.backward(),
        }
    }
    fn send_many(&mut self, commands: Vec<Command>) {
        for command in commands {
            self.send(command);
        }
    }
}

struct Terrain {
    obstacles: Vec<(i32, i32)>,
}
impl Terrain {
    fn new() -> Terrain {
        Terrain { obstacles: vec![] }
    }
    fn with_obstacle(obstacle: (i32, i32)) -> Terrain {
        Terrain {
            obstacles: vec![obstacle],
        }
    }
    fn probe(&self, x: i32, y: i32) -> ProbeResult {
        ProbeResult::TerrainClear
    }
}

#[derive(PartialEq, Eq, Debug)]
enum ProbeResult {
    TerrainClear,
    TerrainBlocked,
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn there_is_a_rover_with_a_position() {
        let rover = Rover::default();
        assert_eq!(rover.position(), "N:0:0");
    }

    #[test]
    fn rover_moves_forward() {
        let mut rover = Rover::default();
        rover.send(Command::Forward);
        assert_eq!(rover.position(), "N:0:1");
    }

    #[test]
    fn rover_moves_backwards() {
        let mut rover = Rover::default();
        rover.send(Command::Back);
        assert_eq!(rover.position(), "N:0:9");
    }

    #[test]
    fn rover_moves_forward_two_times() {
        let mut rover = Rover::default();
        rover.send(Command::Forward);
        rover.send(Command::Forward);
        assert_eq!(rover.position(), "N:0:2");
    }

    #[test]
    fn rover_can_move_backwards_multiple_times() {
        let mut rover = Rover::default();
        rover.send(Command::Back);
        rover.send(Command::Back);
        assert_eq!(rover.position(), "N:0:8");
    }

    #[test]
    fn rover_rotates_left() {
        let mut rover = Rover::default();
        rover.send(Command::Left);
        assert_eq!(rover.position(), "W:0:0");
    }

    #[test]
    fn rover_rotates_left_twice() {
        let mut rover = Rover::default();
        rover.send_many(vec![Command::Left, Command::Left]);
        assert_eq!(rover.position(), "S:0:0");
    }

    #[test]
    fn rover_rotates_left_three_times() {
        let mut rover = Rover::default();
        rover.send_many(vec![Command::Left, Command::Left, Command::Left]);
        assert_eq!(rover.position(), "E:0:0");
    }

    #[test]
    fn rover_rotate_right_three_times() {
        let mut rover = Rover::default();
        rover.send(Command::Right);
        rover.send(Command::Right);
        rover.send(Command::Right);
        assert_eq!(rover.position(), "W:0:0");
    }

    #[test]
    fn rover_cross_to_east_hemisphere() {
        let mut rover = Rover::default();
        rover.send(Command::Left);
        rover.send(Command::Forward);
        assert!(rover.position() == "W:9:0");
    }
    #[test]
    fn rover_cross_to_east_hemisphere_backwards() {
        let mut rover = Rover::default();
        rover.send(Command::Right);
        rover.send(Command::Back);
        assert!(rover.position() == "E:9:0");
    }
    #[test]
    fn rover_cross_to_west_hemisphere() {
        let mut rover = Rover::new(Heading::East, 9, 0);
        rover.send(Command::Forward);
        assert!(rover.position() == "E:0:0");
    }
    #[test]
    fn rover_cross_the_south_edge_backward() {
        let mut rover = Rover::new(Heading::North, 0, 0);
        rover.send(Command::Back);
        assert!(rover.position() == "N:0:9");
    }

    #[test]
    fn terrain_can_be_queried() {
        let t = Terrain::new();
        let result = t.probe(0, 0);
        assert_eq!(result, ProbeResult::TerrainClear);
    }

    #[test]
    fn terrain_has_an_obstacle() {
        let obstacle = (0, 1);
        let t = Terrain::with_obstacle(obstacle);
        let result = t.probe(0, 1);
        assert!(result == ProbeResult::TerrainBlocked);
    }
}
