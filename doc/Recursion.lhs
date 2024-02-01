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

\section{Creating and Solving Mazes}

\section{Solving the n-Queens Problem}

