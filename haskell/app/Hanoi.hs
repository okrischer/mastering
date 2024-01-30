{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE TypeFamilies              #-}

module Main where

import Diagrams.Prelude
import Diagrams.Backend.SVG.CmdLine
import Data.List
import Data.Colour.SRGB (sRGB24read)

-- types to represent the involved data structures
type Disk = Int
type Stack = [Disk]
type Hanoi = [Stack]
type Move = (Int, Int)
type Dia = Diagram B

colors = cycle $ map sRGB24read [
    "#005f73",
    "#0a9396",
    "#94d2bd",
    "#e9d8a6",
    "#ee9b00",
    "#ca6702",
    "#bb3e03",
    "#ae2012"
    ]

-- render a single disk as a rectangle with width proportional to its number
renderDisk :: Disk -> Dia
renderDisk n = rect (fromIntegral n + 2) 1 # lw thin # fc (colors !! n)

-- render a stack of disks by stacking their renderings on top of a peg
renderStack :: Stack -> Dia
renderStack s = disks `atop` peg
  where disks = (vcat . map renderDisk $ s) # alignB
        peg   = rect 0.8 6 # lw none # fc black # alignB

-- render a collection of stacks by distributing them horizontally
renderHanoi :: Hanoi -> Dia
renderHanoi = hcat' (with & catMethod .~ Distrib & sep .~ 7) . map renderStack

-- solve the puzzle and generate a list of moves
solveHanoi :: Int -> [Move]
solveHanoi n = run n 0 1 2 -- call recursive function with start parameters
  where run 0 _ _ _ = [] -- base case: return empty list for zero disks
        run n a b c = run (n-1) a c b -- move n-1 disks from start to temp
                      ++ [(a, c)] -- move one disk from start to goal
                      ++ run (n-1) b a c -- move n-1 disks from temp to goal

-- make a single move and add it to the animation
makeMove :: Move -> Hanoi -> Hanoi
makeMove (x, y) h = h''
  where (d, h')         = removeDisk x h
        h''             = addDisk y d h'
        removeDisk x h  = (head (h !! x), modList x tail h)
        addDisk y d     = modList y (d:)

modList i f l = let (xs, y:ys) = splitAt i l in xs ++ (f y : ys)

-- create the animation as a list of type Hanoi
hanoiSequence :: Int -> [Hanoi]
hanoiSequence n = scanl (flip ($)) [[0..n-1], [], []] (map makeMove (solveHanoi n))

-- render a sequence of configurations by laying them out vertically
renderHanoiSeq :: [Hanoi] -> Dia
renderHanoiSeq = vcat' (with & sep .~ 2) . map renderHanoi

example :: Dia
example = pad 1.1 $ renderHanoiSeq (hanoiSequence 3) # centerXY

main = mainWith example
