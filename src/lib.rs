#![allow(dead_code)]

#[derive(Debug, PartialEq, Eq, Clone, Copy)]
enum Diretion{
    N,
    E,
    S,
    W
}

#[derive(Debug, PartialEq, Eq)]
enum Command{
    Forward,
    Back,
    Left,
    Right
}

#[derive(Default, Debug, PartialEq, Eq, Clone, Copy)]
struct Position {
    x: i32,
    y: i32
}

impl Position {
    fn new(x:i32,y:i32) -> Position {
        Position { x, y }
    }
}

#[derive(Debug, PartialEq, Eq, Clone, Copy)]
struct Rover {
    direction: Diretion,
    position: Position,
    blocked: bool,
}

impl Rover {
    fn default() -> Rover {
        Rover {
            direction: Diretion::N,
            position: Position::new(0,0),
            blocked: false,
        }
    }

    fn send(&mut self, command: Command) {
        let new_rover = apply_command(*self, command);
        *self = new_rover;
    }

    fn send_many(&mut self, commands: Vec<Command>) {
        for command in commands {
            self.send(command);
        }
    }

    fn send_with_terrain(&mut self, command: Command, terrain: &Terrain) {
        let new_rover = apply_command(*self, command);
        match terrain.probe(new_rover.position){
            Probe::Blocked => self.blocked = true,
            Probe::Clear => *self = new_rover,
        }   
    }

    fn send_many_with_terrain(&mut self, commands: Vec<Command>, terrain: &Terrain) {
        for command in commands {
            self.send_with_terrain(command, terrain);
            if self.blocked {
                break;
            }
        }
    }
}

impl std::fmt::Display for Rover {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let blocked = if self.blocked { ":X" } else { "" };
        write!(f, "{:?}:{:?}:{:?}{}", self.direction, self.position.x, self.position.y, blocked)
    }
}


fn apply_command(rover: Rover, command:Command) -> Rover {
    match command {
        Command::Forward => {
            let (x,y) = match rover.direction {
                Diretion::N => (rover.position.x, rover.position.y + 1),
                Diretion::E => (rover.position.x + 1, rover.position.y),
                Diretion::S => (rover.position.x, rover.position.y - 1),
                Diretion::W => (rover.position.x - 1, rover.position.y),
            };
            Rover {
                position: Position::new(x,y),
                ..rover
            }
        }
        Command::Back => {
            let (x,y) = match rover.direction {
                Diretion::N => (rover.position.x, rover.position.y - 1),
                Diretion::E => (rover.position.x - 1, rover.position.y),
                Diretion::S => (rover.position.x, rover.position.y + 1),
                Diretion::W => (rover.position.x + 1, rover.position.y),
            };
            Rover {
                position: Position::new(x,y),
                ..rover
            }
        }
        Command::Left => {
            let direction = match rover.direction {
                Diretion::N => Diretion::W,
                Diretion::E => Diretion::N,
                Diretion::S => Diretion::E,
                Diretion::W => Diretion::S,
            };
            Rover {
                direction,
                ..rover
            }
        }
        Command::Right => {
            let direction = match rover.direction {
                Diretion::N => Diretion::E,
                Diretion::E => Diretion::S,
                Diretion::S => Diretion::W,
                Diretion::W => Diretion::N,
            };
            Rover {
                direction,
                ..rover
            }
        }
    }
}


// fn apply_many(rover: Rover, commands: Vec<Command>) -> Rover{
//     let mut rover = rover;
//     for command in commands {
//         rover = apply_command(rover, command);
//     }
//     return rover;
// }

struct Terrain {
    obstacles: Vec<Position>,
}

#[derive(Debug, PartialEq, Eq)]
enum Probe {
    Clear,
    Blocked,
}

impl Terrain {
    fn new() -> Terrain {
        Terrain {
            obstacles: vec![],
        }
    }

    fn with_obstacle(obstacle: Position) -> Terrain {
        Terrain {
            obstacles: vec![obstacle],
        }
    }

    fn with_obstacles(obstacles: Vec<Position>) -> Terrain {
        Terrain {
            obstacles,
        }
    }

    fn probe(&self, p: Position) -> Probe {
        if self.obstacles.iter().any(|&o| o.x == p.x && o.y == p.y) {
            Probe::Blocked
        } else {
            Probe::Clear
        }
    }
}



#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn there_is_a_rover_with_a_position() {
        let rover = Rover::default();
        assert_eq!(format!("{}", rover), "N:0:0");
    }

    #[test]
    fn rover_moves_forward() {
        let mut rover = Rover::default();
        rover.send(Command::Forward);
        assert_eq!(format!("{}", rover), "N:0:1");
    }

    #[test]
    fn rover_moves_backwards() {
        let mut rover = Rover::default();
        rover.send(Command::Back);
        assert_eq!(format!("{}", rover), "N:0:-1");
    }

    #[test]
    fn rover_moves_forward_two_times() {
        let mut rover = Rover::default();
        rover.send(Command::Forward);
        rover.send(Command::Forward);
        assert_eq!(format!("{}", rover), "N:0:2");
    }

    #[test]
    fn rover_can_move_backwards_multiple_times() {
        let mut rover = Rover::default();
        rover.send(Command::Back);
        rover.send(Command::Back);
        assert_eq!(format!("{}", rover), "N:0:-2");
    }

    #[test]
    fn rover_rotates_left() {
        let mut rover = Rover::default();
        rover.send(Command::Left);
        assert_eq!(format!("{}", rover), "W:0:0");
    }

    #[test]
    fn rover_rotates_left_twice() {
        let mut rover = Rover::default();
        rover.send_many(vec![Command::Left, Command::Left]);
        assert_eq!(format!("{}", rover), "S:0:0");
    }

    #[test]
    fn rover_rotates_left_three_times() {
        let mut rover = Rover::default();
        rover.send_many(vec![Command::Left, Command::Left, Command::Left]);
        assert_eq!(format!("{}", rover), "E:0:0");
    }

    #[test]
    fn rover_rotate_right_three_times() {
        let mut rover = Rover::default();
        rover.send(Command::Right);
        rover.send(Command::Right);
        rover.send(Command::Right);
        assert_eq!(format!("{}", rover), "W:0:0");
    }

    #[test]
    fn rover_cross_to_east_hemisphere() {
        let mut rover = Rover::default();
        rover.send(Command::Left);
        rover.send(Command::Forward);
        assert!(format!("{}", rover) == "W:-1:0");
    }
    #[test]
    fn rover_cross_to_east_hemisphere_backwards() {
        let mut rover = Rover::default();
        rover.send(Command::Right);
        rover.send(Command::Back);
        assert!(format!("{}", rover) == "E:-1:0");
    }
    
    #[test]
    fn terrain_can_be_queried() {
        let t = Terrain::new();
        let result = t.probe(Position::new(0, 0));
        assert_eq!(result, Probe::Clear);
    }

    #[test]
    fn terrain_has_an_obstacle() {
        let obstacle = Position::new(0,0);
        let t = Terrain::with_obstacle(obstacle);
        let result = t.probe(Position::new(0, 0));
        assert!(result == Probe::Blocked);
    }

    #[test]
    fn terrain_has_multiple_obstacles() {
        let obstacles = vec![Position::new(0,0), Position::new(1,1)];
        let t = Terrain::with_obstacles(obstacles);
        let res1 = t.probe(Position::new(1, 1));
        let res2 = t.probe(Position::new(0, 0));
        assert_eq!(res1, Probe::Blocked);
        assert_eq!(res2, Probe::Blocked);
    }

    #[test]
    fn terrain_has_clear_path() {
        let obstacles = vec![Position::new(0,0), Position::new(1,1)];
        let t = Terrain::with_obstacles(obstacles);
        let res = t.probe(Position::new(0, 1));
        assert_eq!(res, Probe::Clear);
    }

    #[test]
    fn rover_can_detect_obstacle() {
        let mut rover = Rover::default();
        let t = Terrain::with_obstacle(Position::new(0,1));
        rover.send_with_terrain(Command::Forward, &t);
        assert_eq!(format!("{}", rover), "N:0:0:X");
    }

    #[test]
    fn rover_can_detect_obstacle_given_list() {
        let mut rover = Rover::default();
        let t = Terrain::with_obstacle(Position::new(0,1));
        rover.send_many_with_terrain(vec![Command::Forward, Command::Left, Command::Left, Command::Forward], &t);
        assert_eq!(format!("{}", rover), "N:0:0:X");
    }
}