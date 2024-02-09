\chapter{Recursion}\label{ch:recursion}

To understand \emph{recursion}, you must first understand
\href{https://www.google.com/search?channel=fs&q=recursion}{recursion}!

A perhaps more helpful explanation:
\begin{quote}
\textbf{Q:} How many twists does it take to srew in a light bulb?

\textbf{A:} Is it already srewed in? Then zero. If not, then twist it once,
ask me again, and add 1 to my answer.
\end{quote}

The goal of this chapter is to demystify recursion and to show that it is actyally
a very practical way to solve problems, which would be quite hard to be solved in a
sequential way (i.e. one step after another).

If I were asked, what the single most effective method would be to design
\emph{declarative} programs, I would certainly answer \emph{recursive programming}.
I dont expect you to follow me at this point, but after working through this
chapter, you might come to the conclusion that this is at least a valid statement.

Instead of boring you with theoretical aspects of recursive programming, I will
try to give some insightful examples, how recursion can speed up your software
design process and eventually could lead to simple and comprehensive solutions.

If you are completely new to the concept of recursion, have a look on this wikipedia
article on \href{https://en.wikipedia.org/wiki/Recursion_(computer_science)}{recursion}
to get you started.
There are a lot of other resources on the topic for every programming language out there,
so please feel free to choose some of your liking, digest them, and then come back to
this document.

Having a rough understanding of recursion, let's just jump right into the topic.

\section{Towers of Hanoi}

The \href{https://en.wikipedia.org/wiki/Tower_of_Hanoi}{Towers of Hanoi} puzzle
was originally meant as a recreational toy, invented by the French mathematician
Èdouard Lucas in 1883.

For our purpose, we want to find a programatic solution to this puzzle with 8 disks.

Think for a moment and try to come up with an imperative solution.
What are the $2^8 - 1 = 255$ moves and in which order should they be executed?

If we can't find an imperative solution easily, we need onother way to solve this riddle.
The plan for our solution is a simple thought:

\begin{enumerate}
  \item move (n-1) disks from the starting tower to the temporary tower
  \item move the largest disk from start to goal
  \item move the (n-1) disks from temp to goal
\end{enumerate}

And that's it! No redo, no more thoughts!
Convince yourself, based on figure~\ref{fig:hanoi_plan}, that this plan should work
(the towers from left to right are: start, temp, goal).

\begin{figure}[ht]
  \centering
  \includesvg[scale=0.3]{../img/hanoi_plan.svg}
  \caption[ToH Solution Plan]{Solution plan for solving Towers of Hanoi with n disks}
  \label{fig:hanoi_plan}
\end{figure}

There remains only one question: how, for heaven's sake, can we put our plan into action?
And the answer is: recursion!

\subsection{Haskell}

It is time to actually solve the problem with a concrete implementation.
In Haskell this could look like so:

\begin{code}
module Recursion where
import Data.List (permutations)
import qualified Control.Applicative as case

type Move = (Int, Int)                        -- (1)

solveHanoi :: Int -> [Move]
solveHanoi n = run n 0 1 2                    -- (2)
  where run 0 _ _ _ = []                      -- (3)
        run n a b c = run (n-1) a c b         -- (4)
                      ++ [(a, c)]             -- (5)
                      ++ run (n-1) b a c      -- (6)
\end{code}

The logic of \mintinline{haskell}{solveHanoi} is as follows:
\begin{enumerate}
  \item declare a data structure to capture the moves (a tuple of ints)
  \item call local recursive function with start parameters (the towers)
  \item base case: return empty list for zero disks
  \item recursive case: move n-1 disks from start to temp
  \item recursive case: capture move for one disk
  \item recursive case: move n-1 disks from temp to goal
\end{enumerate}

The logic of the recursive cases follows exactly our solution design and represents a truly
\emph{declarative program}: we only specify, \emph{what} we want to achieve and don't
care about \emph{how} the compiler is going to accomplish this.

For n = 3, the function will return this list of moves: \\
\texttt{[(0,2),(0,1),(2,1),(0,2),(1,0),(1,2),(0,2)]}, \\
where each tuple represents a move from the first (a, *) to the second (*, b) tower.

Remember, that for every move we always move the topmost disk of tower \textbf{a} to
tower \textbf{b}, so there is no need to specify which disk to move.
In consequence, the list of moves is all the information we need to actually solve the puzzle.

Also, observe the number of moves (7) which is the shortest possible sequence for
solving the problem: $moves = 2^n - 1 = 2^3 - 1 = 7$.

Figure~\ref{fig:hanoi_solved} shows a pictorial representation of solving the puzzle with
these informations.

\begin{figure}[ht]
  \centering
  \includesvg[scale=0.3]{../img/hanoi}
  \caption[Towers of Hanoi solved]{Solving Towers of Hanoi with 3 disks}
  \label{fig:hanoi_solved}
\end{figure}

If you are interested in how to create a representation like figure~\ref{fig:hanoi_solved}
with Haskell, have a look at the sourcecode in file \texttt{haskell/app/Hanoi.hs} from the
code repository.
This example is taken from the \href{https://hackage.haskell.org/package/diagrams}{diagrams}
package, a DSL (domain-specific language) for creating vector graphics with Haskell.
In case you want to learn functional programming from the ground up, I can think of
no better way than working through the diagram
\href{https://diagrams.github.io/tutorials.html}{tutorials}.
If these tutoraials go over your head as a Haskell newcomer, consider working through
a general introduction like \href{http://learnyouahaskell.com/chapters}
{Learn You a Haskell for Great Good!} at first.

To create the picture, make sure that the file \texttt{haskell/mastering.cabal}
contains the line \\
\texttt{main-is:  Hanoi.hs} \\
and then execute \texttt{<cabal exec mastering -- -o ../img/hanoi.svg -w 400>}
from your terminal inside the directory \texttt{haskell}.

\subsection{$C^{++}$}\label{subsec:cpprec}

Now that we know how to solve the puzzle with Haskell, it is time to solve it with $C^{++}$.
How can we appoach this, using an imperative language?

The simple answer is: we do exactly the same, which leads to the following implementation:

\begin{cpp}
auto* moves = new List<std::pair<char, char>>;   // (1)

void solve(int n, char s, char t, char g) {      // (2)
  if (n == 0) return;                            // (3)
  solve(n-1, s, g, t);                           // (4)
  moves->push_back(std::make_pair(s,g));         // (5)
  solve(n-1, t, s, g);                           // (6)
}
\end{cpp}

The logic of \mintinline{cpp}{solve}:
\begin{enumerate}
  \item declare a data structure to capture the moves
  \item top-level recursive function with start parameters (the towers)
  \item base case: do nothing for zero disks
  \item recursive case: move n-1 disks from start to temp
  \item recursive case: capture move for one disk
  \item recursive case: move n-1 disks from temp to goal
\end{enumerate}

I'm using a \mintinline{cpp}{list::List} for capturing the moves,
which is a linked list, implementing the \emph{FIFO} principle.
We will discuss Lists in §~\ref{sec:lists}.

It is perfectly legal to use recursion in $C^{++}$, as most compilers provide
\href{https://en.wikipedia.org/wiki/Tail_call}{tail-call optimization}
(at least when compiled with optimizations, e.g. with flag -O3).
If the optimization went well (which is actually hard to check), your recursive programs will not
be any slower than using an imperative for-loop.
But, when the number of recursive calls increases, this will eventually consume your computers memory.

Let's make an experiment: call a modified version of \mintinline{cpp}{solve}
with a larger number of disks, say 30, and just comment out step 5
(enqueuing the moves).
This will result in $2^{30} - 1 = 1073741823$ (one billion) recursive calls,
which are handeled in less than a second on my machine (AMD Ryzen 9 5900HX
with 8 physical cores and 32 GiB RAM), and without any noticeable memory consumption.

But when I call the original function (with queuing enabled), the program runs
for about 20 seconds, before it is finally killed by the operating system.
The program has consumed all available RAM (on my machine more than 28 GiB) and
still didn't manage to compute all necessary moves.

That problem is not genuinely rooted in a failed tail-call optimization;
on the contrary, it shows that the program is very fast and handles the recursion without
exhausting the stack (in which case we would have gotten an exception from the program).

The problem is rooted in the very recursive nature of the task at hand:
we are doomed to complete the recursive loop and to store all intermediate results in a
data structure, before we can use those results for further processing.
This, in turn, allocates more and more memory (on the heap in this case,
as I'm creating objects with a call to \mintinline{cpp}{new}).
If we could use an imperative for-loop, we would be able to process every move directly after
computing it, and there would be no need to store the moves.

In our case (computing a solution with a maximum of 8 disks and 255 recursive calls),
it is a valid trade-off to use recursion (with a slightly higher memory consumption)
instead of developing an imperative solution (which might even not exist).
Thus, we will stick to our solution, and explore how to use it in order to create
a nice animation:

\begin{cpp}
auto* start = new List<int>;
auto* temp = new List<int>;
auto* goal = new List<int>;

void makeMove(std::pair<char, char> move) {
  auto from = getTower(move.first);
  auto to = getTower(move.second);
  to->push_front(from->pop());
}

// make next move
try {
  auto move = moves->pop();
  makeMove(move);
} catch (std::out_of_range& e) {
  std::cout << "successfully displayed animation.\n";
  window.close();
  return 0;
}
\end{cpp}

This code uses three stacks to implement the \emph{start}, \emph{temp}, and \emph{goal}
towers for storing the current configuration.
Each stack is implemented as a \mintinline{cpp}{List<int>}, but this time we're applying the
\emph{LIFO} principle by using the \mintinline{cpp}{push_front} method, instead of
\mintinline{cpp}{push_back}, which we used to implement the moves queue.

The actual work is done in the bottom part of the code snippet within the \mintinline{cpp}{try-catch}
block:
if there is another move in the moves-queue (\mintinline{cpp}{try} is successful), make the move by
calling \mintinline{cpp}{makeMove}.
Otherwise just end the animation (\mintinline{cpp}{catch} block).

The animation itself is implemented with \href{https://www.sfml-dev.org/}{SFML} for $C^{++}$.
If you're interested in how this works, have a look at \texttt{applications/hanoi.cpp}.
After compiling the whole project with \texttt{<cmake --build .>} from the \texttt{build} folder,
you can run the hanoi animation with e.g. \texttt{<./Hanoi 4 1>}, where the first parameter is the
number of disks, and the second is the delay in seconds between the frames of the animation.

\section{Drawing Fractals}


\section{Solving the n-Queens Problem}

The \href{https://en.wikipedia.org/wiki/Eight_queens_puzzle}{n-queens problem} is the problem
of placing $n$ non-attacking queens on an $n \times n$ chessboard.
Solutions exist for all natural numbers $n$ with the exception of $n = 2 \ \text{and} \ n = 3$.

Although the exact number of solutions is only known for $n \leq 27$, the asymptotic growth
rate of the number of solutions is approximately $(0.143 n)^n$. 

We'll explore two different \emph{recursive} algorithms for solving the problem,
the first using \emph{generate and test} in Haskell, and the other using \emph{backtracking}
in $C^{++}$.

\subsection{Generate And Test}

\emph{Generate and test} algorithms belong to the domain of \emph{searching} algorithms
and are widely used in functional languages to solve combinatorial problems.
While there are many subfields of \href{https://en.wikipedia.org/wiki/Combinatorics}
{combinatorics} and many related problems, they all have in common that the search
space is growing very quickly and they usually do not show any monotonic property, which
could be exploited to reduce the search space.

So, the idea is to generate all possible solution candidates at first, and then to filter out
the valid ones (the test step), following this pattern:

\begin{spec}
solutions = filter valid . candidates
\end{spec}

For the n-queens problem there are $\binom{64}{8} = 4,426,165,368$ ways to place 8 queens
on a $8 \times 8$ chessboard.
There is no hope of solving a problem with such a big search space in reasonbale time.
For that, we need to \emph{constrain} the generating function in order to generate only
\emph{good} candidates, which are more likely to be actual solutions.

Our method for solving this problem will take into account the observation that there
will always be one queen in each column: if there were two or more then they would
be able to attack each other, and if there were none then some other column would have
at least two.
This will reduce the search space to $8^8 = 16,777,216$ possible solutions.

We'll label rows and columns with integers, and positions on the board with their
coordinates.
The solutions are boards, which are lists giving the row numbers of the queens in
each column.

\begin{code}
type Row = Int
type Col = Int
type Coord = (Col, Row)
type Board = [Row]

queens1 :: Col -> [Board]
queens1 0 = [[]]                   -- base case: return empty board
queens1 n = [q:qs | q <- [1..8],
            qs <- queens1 (n-1),   -- recursion: fill remaining rows
            and [not (attack (1, q) (x, y)) | (x, y) <- zip [2..n] qs]]

attack :: Coord -> Coord -> Bool
attack (x, y) (x', y') =
  y == y'               -- same row
  || x + y == x' + y'   -- same left diagonal
  || x - y == x' - y'   -- same right diagonal
\end{code}

The main part of that algorithm is the recursive call, where we fill in the row numbers
for the remaining columns.
Observe, that we've included the test step within the generating function
(\mintinline{haskell}{not . attack}), which is a good thing as only valid solutions
are generated, and we don't need to keep track of the unvalid ones.
Unfortunately, all $8^8$ combinations still have to be evaluated,
which leads to a poor performance of the algorithm.

To test the performance, set the \texttt{+s} flag in ghci with \texttt{:set +s} and
then call \texttt{head (queens 8)} with the file \texttt{Recursion.lhs} loaded.
That will display the first solution and the time taken to find it, which - on my
machine - is 4 seconds.
When you call \texttt{length (queens 8)}, you will experience even longer running times
(on my machine 59 seconds).
The reason for that big difference in running time is that we are working with lazy lists
in Haskell.
So, when you call \texttt{head} the algorithm is aborted after retrieving the
first solution, whereas calling \texttt{length} needs to retrieve all solutions.

But, fortunately, there is room for improvement: if we only check all permutations of
the row numbers \mintinline{haskell}{[1..8]}, this will reduce the search space to
$8! = 40,320$ combinations, and we don't need the test for the same row anymore, as every
row number will be unique.

\begin{code}
queens2 :: Int -> [Board]
queens2 n = filter valid $ permutations [1..n]

valid :: Board -> Bool
valid qs = and [not (attack' p p') | [p, p'] <- choose 2 $ zip [1..] qs]

attack' :: Coord -> Coord -> Bool
attack' (x, y) (x', y') = abs (x-x') == abs (y - y')

choose :: Int -> [a] -> [[a]]
choose 0 xs = [[]]
choose k [] = []
choose k (x:xs) = choose k xs ++ map (x:) (choose (k-1) xs)
\end{code}

When you call this implementation, you will see that it is much more efficient as our
first solution: on my machine it takes only 350 ms to compute all 92 solutions.

With this implementation, the testing function \mintinline{haskell}{valid} seems to
do the main work: it checks wether every given queen coordinate from the solution
candidate is indeed save, i.e. it cannot be attacked by any of the other queens.
The \mintinline{haskell}{attack'} function was simplified to only one statement, which checks
only the diagonals, as queens are guaranteed not to sit on the same row or column.

But the real (recursive) work is done by the library function \mintinline{haskell}
{permutations}, which produces all permutations of the given input list.
This is not a bad thing per se, but as this chapter is about recursion, we'll create
another solution, making the recursion more explicit.
While we are at it, we will also include the test step in the generating function,
as we did in our first solution.

\begin{code}
queens3 :: Int -> [Board]
queens3 n = run n where
    run 0 = [[]]
    run r = [q:qs | q <- [1..n], qs <- qss, q `notElem` qs, save q qs]
      where qss = run (r-1)

save :: Int -> [Int] -> Bool
save q qs = and [abs (q - q') /= r' - 1 | (r', q') <- zip [2..] qs]
\end{code}

And here you have it: a very compact recursive algorithm, generating and testing all
sulution candidates in one step.
This version of the algorithm is optimized to generate all solutions, and when I call
it with \texttt{length (queens3 8)} on my machine, it computes all 92 solutions in just 20 ms.

\subsection{Backtracking}

\emph{Backtracking} does basically the same that the \emph{generate and test} algorithm
from the last section did: it searches a non-monotonic search-space for solutions
that match some pre-defined constraints.
But in contrast to the former, it doesn't need to generate a list of all possible candidates;
instead, it is just modifying a single instance of a solution candidate.

This is possible because in an imperative language we have direct access to the underlying
contiguous memory, providing constant time access to arbitrary elements of the solution
candidate.
We're also able to update elements of the solution candidate in place, which leads
to a much smaller space complexity than in an functional setting.

With all that in mind, a recursive backtracking solution for the n-queens problem can be
implemented like so:

\begin{cpp}
int solutionCount = 0;
std::vector<int> board;

bool isSafe(std::vector<int> const& board, int row) {
  for (int col = 0; col < row; col++) {
    if (board[col] == board[row]) return false;
    if (abs(board[row] - board[col]) == row - col) return false;
  }
  return true;
}

void placeQueen(std::vector<int>& board, int row) {
  int sz = board.size();
  if (row == sz) {                                        // (2)
    printBoard(board);
    solutionCount++;
  } else {
    for (int col = 0; col < sz; col++) {                  // (3)
      board[row] = col;
      if (isSafe(board, row))
        placeQueen(board, row + 1);                       // (4)
    }
  }                                                       // (5)
}

board = std::vector<int>(8, 0);
placeQueen(board, 0);                                     // (1)
\end{cpp}

The logic is comparable to that of \mintinline{haskell}{queens1}:
\begin{enumerate}
  \item start the computation by calling the recursive function \texttt{placeQueen}
  with the initial solution candidate (a vector of 8 columns, all set to 0)
  \item base case: if all row numbers are already set, we have a solution and
  increase the solution counter; optionally print out the solution
  \item recursive case: iterate over all columns of the candidate and check wether a
  queen can be put savely at this position
  \item recursive call: if the position is safe, call \texttt{placeQueen} with next row 
  \item if the queen cannot be placed savely, do nothing.
\end{enumerate}

There is nothing new for the testing function \mintinline{cpp}{isSafe}, so we will
concentrate on the recursive function \mintinline{cpp}{placeQueen}:\\
we have two loops: the recursive outer loop, running through the row numbers, and an
inner for-loop, iterating over the colomns.

If a queen can be placed safely on the given row, the algorithm continues with a recursive
call to the next row.
But, when a queen connot be placed on that row, we do nothing.

What happens if we do nothing in a recursive setting?\\
Well, all the recursive instructions, stored on the stack, are executed in reverse order,
until the last recursive call is reached.
And since we have done nothing, the computation is just set back to the point of the last recursive
call.
Then the process continues at this point.

So, what the algorithm really does is that:\\
it tries to find a column in which a queen can be put for the current row (starting with 0).
If that does not succeed, it rolls back the computation to the preceeding row,
places a queen in the next safe column of that row and continues with checking the next row.
Because of the intertwining of inner and outer loop we can reach the base case several times, 
namely every time when all row numbers have been set, i.e. a solution is found.
But the computation does not necessarily stop at that point: there is no \mintinline{cpp}{return}
statement in the base case.
It only stops if no more solutions are found, i.e. all nested recursive calls are processed.

Now you could think that this algorithm has to check all $8^8 = 16,777,216$ combinations like
our first haskell version did, but that's not the case.
Because the algorithm rejects attacking positions even on incomplete boards, setting back the
search to the last valid candidate, it examines actually only 15,720 possible queen placements.
Together with the fact, that we're using fast in-place updates on a small data structure, the
algorithm is very fast.
On my machine it took only 5 ms to compute and print all 92 solutions.

Of course, you could implement the row-loop with an iterative for-loop as well.
But then you would have to keep \emph{track} of the last valid combination explicitly,
and set the search \emph{back} to that point in case the constraint cannot be satisfied.
Hence the name \emph{backtracking}.
