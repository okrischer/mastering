\chapter{Lists}\label{ch:lists}

A \emph{list} is a linear recursive data structure.
When creating a list, you get some kind of reference to its first element, every element
pointing to exactly one next element.
Thus, traversing a list (e.g. for finding an element) requires a runtime of $\Theta(n)$,
where n is the number of elements in that list.
If you are not familiar with \emph{asymptotic notation} and how I use it in this document,
please consult §~\ref{sec:runtime}.

However, getting from one element to the next is guaranteed to take only constant time
regardless of where the objects are actually located on the heap.
So, if you have to traverse the whole list anyway (i.e. when you need to process every
element in it), lists give you a very simple, powerful and fast way to do so.

\section{Lists in Haskell}

As already mentioned, lists are the workhorse of functional languages in general;
you may encounter them literally anywhere in a functional program, Haskell beeing no
exception.
We are not going to concentrate on functional lists in this chapter.
But you may want to get a feeling about how they are used in those languages, if only to
understand, how they might be useful in an imperative language.

So please, go ahead and make yourself acquainted with lists, perhaps by working through
parts 1 to 3 of this tutorial:
\href{http://wiki.haskell.org/H-99:_Ninety-Nine_Haskell_Problems}{Ninety-Nine Haskell Problems}.

Here's a quite elaborated example in Haskell, which implements and cracks the
\href{https://en.wikipedia.org/wiki/Caesar_cipher}{Caesar cipher} using lists:

\begin{code}
module Datastructures where
import Data.Char

char2int :: Char -> Int
char2int c = ord c - ord 'a'

int2char :: Int -> Char
int2char n = chr (ord 'a' + n)

shift :: Int -> Char -> Char                                -- (1)
shift n c
  | isLower c = int2char ((char2int c + n) `mod` 26)
  | otherwise = c

encode :: Int -> String -> String                           -- (2)
encode n xs = [shift n x | x <- xs]

table :: [Float]
table = [8.1, 1.5, 2.8, 4.2, 12.7, 2.2, 2.0, 6.1, 7.0,
        0.2, 0.8, 4.0, 2.4, 6.7, 7.5, 1.9, 0.1, 6.0,
        6.3, 9.0, 2.8, 1.0, 2.4, 0.2, 2.0, 0.1]

percent :: Int -> Int -> Float                              -- (3)
percent n m = (fromIntegral n / fromIntegral m) * 100

count :: Char -> String -> Int                              -- (4)
count x xs = length [x' | x' <- xs, x == x']

lowers :: String -> Int                                     -- (5)
lowers xs = length [x | x <- xs, isAsciiLower x]

positions :: Eq a => a -> [a] -> [Int]                      -- (6)
positions x xs = [i | (x', i) <- zip xs [0..], x == x']

freqs :: String -> [Float]                                  -- (7)
freqs xs = [percent (count x xs) n | x <- ['a'..'z']]
  where n = lowers xs

chisqr :: [Float] -> [Float] -> Float                       -- (8)
chisqr os es = sum [((o-e)^2)/e | (o, e) <- zip os es]

rotate :: Int -> [a] -> [a]                                 -- (9)
rotate n xs = drop n xs ++ take n xs

crack :: String -> String                                   --(10)
crack xs = encode (-factor) xs
  where
    factor = head (positions (minimum chitab) chitab)
    chitab = [chisqr (rotate n table') table | n <- [0..25]]
    table' = freqs xs

\end{code}

This program consists of several functions:
\begin{enumerate}
  \item shift a lowercase character n positions and wrap around at the end of alphabet
  \item encode a string by shifting every character, using a list comprehension
  \item percent: calculates the relation of 2 integers and returns a percentage as float
  \item counts the occurence of a given character in a string
  \item lowers: counts all the lowercase characters in a string
  \item positions: returns a list of all positions at which a value occurs in a list
  \item freqs: calculates and returns a frequency table for any given string
  \item chisqr: calculates a chi-square statistic of observed and expected values
  \item rotate the elements of a list n places to the left, wrapping around at list start
  \item cracks a given cipher and returns clear text without knowing the key (main function)
\end{enumerate}

Now, it is your turn: try to understand what these functions are doing and how they
employ lists and list comprehensions to accomplish this. \\
Nothing is gained, if you just skim over and have no understandig of what's going on!

Once you have a good feeling about what the program does, load this file
into ghci: \texttt{<ghci List.lhs>} and play with it.
You could, for example, evaluate the following expressions:

\begin{spec}
message = "declarative programming rules!"
encoded = encode 7 message
decoded = encode (-7) encoded
decoded == message
-- and then crack your code without specifying the key!
crack encoded == message
\end{spec}

Notice, that the code above is not part of the sourcecode of this file, as Haskell
does not allow anything else than top-level declarations in sourcecode.
You have to type in these expressions in ghci for yourself.

A last brain teaser: why can't you crack an encoded clear-text message like
"boxing wizards jump quickly" with that program?

Now, to something completely different: lists with $C^{++}$.

\section{Lists with $C^{++}$}\label{sec:lists}

The first thing we need, is a new type of objects to hold data of any other type and
a pointer to another object of its own type.
We'll call this type \mintinline{cpp}{Node}.

\begin{cpp}
template<typename T>
class Node {
public:
  T data;
  Node* next;

  Node(T d, Node* n) : data{d}, next{n} {}
  ~Node() {}
};
\end{cpp}

Next, we define the public interface for lists by creating an abstract class, which contains
only virtual functions:

\begin{cpp}
template<typename T>
class List {
public:
  virtual ~List() {}
  virtual int size() const = 0;
  virtual T peek(int n) const = 0;
  virtual T pop() = 0;
  virtual void push_back(T elem) = 0;
  virtual void push_front(T elem) = 0;
};
\end{cpp}

The type \mintinline{cpp}{List} is a pure interface, so you can't instanciate any objects from it.
In order to do so, we need a concrete type, which implements the interface and overrides all
virtual methods:

\begin{cpp}
template<typename T>
class Queue : public List<T> {
public:
  Queue() : head{nullptr}, tail{nullptr}, sz{0} {}
  ~Queue() {
    Node<T>* node = head;
    while(node) {
      Node<T>* curr = node;
      node = node->next;
      delete curr;
    }
  }

  // size returns the current size of the list.
  int size() const override {return sz;}

  // peek returns the element with the given index (starting with 1).
  // If there is no element at the given index, an exception is thrown.
  T peek(int n) const override {
    Node<T>* node = head;
    for (int i = 1; i < n && i < sz; i++) {
      node = node->next;
    }
    if (node) return node->data;
    else throw std::out_of_range{"Queue::peek()"};
  }

  // pop removes and returns the head of the list.
  // If the list is empty, an exception is thrown.
  T pop() override {
    if (head) {
      Node<T>* first = head;
      T elem = head->data;
      head = head->next;
      delete first;
      sz--;
      return elem;
    } else throw std::out_of_range{"Queue::pop()"};
  }

  // push_front inserts a new element at the head of the list.
  void push_front(T elem) override {
    head = new Node<T>(elem, head);
    if (!tail) tail = head;
    sz++;
  }
  // push_back inserts a new element at the tail of the list.
  void push_back(T elem) override {
    if (!tail) {
      head = new Node<T>(elem, head);
      tail = head;
    } else {
      tail->next = new Node<T>(elem, nullptr);
      tail = tail->next;
    }
    sz++;
  }

private:
  Node<T>* head;
  Node<T>* tail;
  int sz;
};
\end{cpp}

Now, let's put \mintinline{cpp}{Queue} into action by solving some exercises.
Don't worry if you cannot solve them off the cuff; all exercises have detailled solutions
in appendix~\ref{ch:solutions} \emph{Solutions to the exercises}.
But make sure to give them a honest try at first, otherwise you will learn nothing from them.

\begin{exs}\label{exs:balanced}
Create a $C^{++}$ program to check for balanced brackets of a given string.\\
\emph{Hint:} use \mintinline{cpp}{Queue} as a LIFO data structure (aka a stack),
i.e. employ its methods \mintinline{cpp}{push_front} and \mintinline{cpp}{pop}.
\end{exs}

\begin{exs}\label{exs:balhask}
Solve exercise~\ref{exs:balanced} with Haskell.
\end{exs}

\begin{exs}\label{exs:palindrome}
Create a $C^{++}$ program to check wether a given string is a
\href{https://en.wikipedia.org/wiki/Palindrome}{palindrome}.\\
\emph{Hint:} use two \mintinline{cpp}{Queue}s, one as a stack and the other as a queue.
\end{exs}

\begin{exs}\label{exs:palhask}
Solve exercise~\ref{exs:palindrome} with Haskell.
\end{exs}
