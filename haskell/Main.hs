module Main where

main :: IO ()
main = do
  print(food_per_step)
  print(time)
 -- print(div time steps_per_second)
 -- (state, _) <- return $ simulate_until(start_state, 0)
  --print(state)


steps_per_second = 2 * machines_num
machines_num = 1000
eat_at_once = 12
eat_interval = 2 * steps_per_second
max_space = 1200
food_per_step = (div (machines_num * eat_at_once) eat_interval) * 2

data Dir = Feed | Away deriving(Show, Eq)

data Manifold = Manifold !Dir !Int !Int !Int deriving(Show)

machine_step :: Int -> Int -> Int -> (Int, Int, Int)
machine_step space hunger food =
    let hunger' = hunger + 1
        space' = space - food
        will_eat = hunger' >= eat_interval && (max_space - space') >= eat_at_once
        (space'', hunger'') = if will_eat then (space' + eat_at_once, 0)
                                          else (space', hunger')
        overflow = if space'' < 0 then -space'' else 0
    in ((space'' + overflow), hunger'', overflow)

splitter_step :: Manifold -> Manifold
splitter_step (Manifold dir space hunger food) =
    let split_away = if dir == Feed then food `div` 2
                                    else food - (food `div` 2)
        split_feed = food - split_away
        (space', hunger', leftovers) = machine_step space hunger split_feed
        dir' = if leftovers > 0
               then Feed
               else case split_feed `compare` split_away
                    of LT -> Feed
                       EQ -> dir
                       GT -> Away
    in Manifold dir' space' hunger' (leftovers + split_away)

step :: [Manifold] -> [Manifold]
step [Manifold _ space hunger food] = let (space', hunger', _) = machine_step space hunger food
                                 in [Manifold Feed space' hunger' 0]
step (man:ss) = (splitter_step man):(step ss)

start_state = take machines_num $ repeat $ Manifold Away max_space eat_interval 0

step_feed :: [Manifold] -> [Manifold]
step_feed state = step $ shift_feed state food_per_step

simulate_until :: ([Manifold], Int) -> ([Manifold], Int)
simulate_until (ss, n) = if all_fed ss then (ss, n) else simulate_until $ (step_feed ss, n + 1)

time :: Int
time = let (_, steps) = simulate_until (start_state, 0)
       in steps

all_fed :: [Manifold] -> Bool
all_fed [m1, m2] = fed m1 && fed m2
all_fed (m:ms) = full m && all_fed ms

full (Manifold _ space _ _) = space <= eat_at_once

fed (Manifold _ _ hunger _) = hunger < eat_interval

shift_feed :: [Manifold] -> Int -> [Manifold]
shift_feed [] _ = []
shift_feed ((Manifold d s h f):ss) feed = (Manifold d s h feed):(shift_feed ss f)

{-
data Machine = Machine !Int !Int
instance Show Machine where
    show (Machine space hunger) = show $ max_space - space

data Dir = Feed | Away deriving(Show)

data Manifold = Manifold !Dir !Machine !Int

machine_step :: Machine -> Int -> (Machine, Int)
machine_step (Machine space hunger) food = overflow . machine_eat $ Machine (space - food) hunger

machine_eat :: Machine -> Machine
machine_eat (Machine space hunger)
    | (max_space - space) >= eat_at_once && hunger + 1 >= eat_interval = Machine (space + eat_at_once) 0
    | otherwise = Machine space (hunger + 1)

overflow :: Machine -> (Machine, Int)
overflow (Machine space hunger)
    | space < 0 = (Machine 0 hunger, -space)
    | otherwise = (Machine space hunger, 0)

splitter_step :: Manifold -> Manifold
splitter_step (Manifold dir machine food) =
    let (solo_dir, solo_remains) = solo_splitter_step dir food
        (machine', machine_remains) = machine_step machine (food - solo_remains)
        dir' = if machine_remains > 0 then Feed else solo_dir
    in Manifold dir' machine' (machine_remains + solo_remains)

solo_splitter_step :: Dir -> Int -> (Dir, Int)
solo_splitter_step Further 0 = (Further, 0)
solo_splitter_step Further food = (dir', remains' + 1)
    where (dir', remains') = solo_splitter_step Feed (food - 1)
solo_splitter_step Feed food
    | even(food) = (Feed, div food 2)
    | otherwise = (Further, div food 2)

step :: [Manifold] -> [Manifold]
step [Manifold _ machine food] = let (machine', _) = machine_step machine food
                            in [Manifold Feed machine' 0]
step (man:ss) = (splitter_step man):(step ss)

simulate :: Int -> [Manifold]
simulate 0 = take machines_num $ repeat $ Manifold Further (Machine max_space eat_interval) 0
simulate n = step_feed . simulate $ n - 1

step_feed :: [Manifold] -> [Manifold]
step_feed state = step $ shift_feed state food_per_step

simulate_until :: ([Manifold], Int) -> ([Manifold], Int)
simulate_until (ss, n) = if all_fed (machines ss) then (ss, n) else simulate_until $ (step_feed ss, n + 1)

time :: Int
time = let (_, steps) = simulate_until ((simulate 0), 0)
       in div steps steps_per_second

machines :: [Manifold] -> [Machine]
machines [] = []
machines ((Manifold _ m _):ss) = m:machines ss

all_fed :: [Machine] -> Bool
--all_fed ms = af ms True
all_fed [m1, m2] = fed m1 && fed m2
all_fed (m:ms) = full m && all_fed ms

af [m1, m2] res = fed m1 && fed m2 && res
af (m:ms) res = af ms (aand  (full m) $! res)

aand b1 b2 = b1 && b2

full (Machine space _) = space <= eat_at_once

fed (Machine _ hunger) = hunger < eat_interval

shift_feed :: [Manifold] -> Int -> [Manifold]
--shift_feed ms feed = shift_feed' [] feed ms

shift_feed [] _ = []
shift_feed ((Manifold d m f):ss) feed = (Manifold d m feed):(shift_feed ss f)

shift_feed' res _ [] = res
shift_feed' res feed ((Manifold d m f):remain) = shift_feed' (stuff $!  res) f remain
    where stuff res = res ++ [Manifold d m feed]

-}
