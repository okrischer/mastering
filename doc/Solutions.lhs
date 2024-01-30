\chapter{Solutions to the Exercises}\label{ch:solutions}

\section{Lists}

\paragraph{Exercise~\ref{exs:balanced}} ~\\

\begin{cpp}
bool is_balanced(std::string s) {
  std::map<char, char> matcher{{'}', '{'}, {']', '['}, {')', '('}};
  auto stack = list::Queue<char>{};

  for (char c : s) {                                          // (1)
    if (c == '{' || c == '[' || c == '(') stack.push_front(c);// (2)
    else if (c == '}' || c == ']' || c == ')') {              // (3)
      if (stack.size() == 0) return false;                    // (4)
      if (matcher[c] != stack.pop()) return false;            // (5)
    }
  }
  return stack.size() == 0;                                   // (6)
}
\end{cpp}

I'm using a \mintinline{cpp}{Queue} as a stack for keeping track of opening brackets,
and a \mintinline{cpp}{map} for matching opening and closing brackets.\\
The algorithm traverses all characters of the input string (1) and pushes all opening brackets
onto the stack (2).\\
If the character is a closing bracket (3), we check wether the stack is empty and, if so, terminate
with result false (4).\\
If the stack is not empty and the closing bracket does not correspond to the last opening bracket,
we terminate as well with result false (5).\\
Finally, we check wether the stack is empty and return that result as the final result (6).

\paragraph{Exercise~\ref{exs:balhask}} ~\\

Using \emph{recursion \text{and} pattern matching}, the check for balanced brackets can be
implemented like so:

\begin{code}
balanced :: String -> Bool
balanced xs = check xs []                                   -- (1)

check :: String -> String -> Bool
check [] stack = null stack                                 -- (2)
check (x:xs) stack                                          -- (3)
  | isOpening x = check xs (x:stack)                        -- (4)
  | isClosing x = case stack of                             -- (5)
                  [] -> False                               -- (6)
                  (y:ys) -> matcher y x && check xs ys      -- (7)
  | otherwise   = check xs stack                            -- (8)

isOpening :: Char -> Bool
isOpening x = x `elem` "{[("

isClosing :: Char -> Bool
isClosing x = x `elem` "}])"

matcher :: Char -> Char -> Bool
matcher y x = Just x == lookup y table

table :: [(Char, Char)]
table = [('{', '}'), ('[', ']'), ('(', ')')]
\end{code}

Observe, that I'm applying the same logic as with the imperative solution, only using
recursion instead of a for-loop:
\begin{enumerate}
  \item call recursive function with empty stack
  \item base case (empty input): check for empty stack and return that result
  \item recursive cases (non-empty input)
  \item first character is an opening bracket: continue with
        remaining characters and push x onto the stack
  \item first character is a closing bracket
  \item return \mintinline{haskell}{False} if stack is empty
  \item if stack is not empty, compare x with top element from stack and if it matches,
        continue with remaining elements, otherwise return \mintinline{haskell}{False}
  \item continue with remaining characters
\end{enumerate}

If you know how to use \emph{higher-order} functions like
\href{https://hackage.haskell.org/package/base-4.19.0.0/docs/Prelude.html#v:foldl}{foldl} and
\href{https://hackage.haskell.org/package/base-4.19.0.0/docs/Prelude.html#v:filter}{filter}
in Haskell, you can solve the problem with a one-liner and a helper-function like so:

\begin{code}
brackets :: String -> Bool
brackets xs = null $ foldl match [] $ filter (`elem` "{[()]}") xs

match :: String -> Char -> String
match ('{' : xs) '}' = xs
match ('[' : xs) ']' = xs
match ('(' : xs) ')' = xs
match xs x           = x:xs
\end{code}

\paragraph{Exercise~\ref{exs:palindrome}} ~\\

\begin{cpp}
bool is_palindrome(std::string s) {
  auto stack = list::Queue<char>{};
  auto queue = list::Queue<char>{};
  bool palindrome = true;

  for (auto c : s) {
    if (isalpha(c)) {
      char l = tolower(c);
      stack.push_front(l);
      queue.push_back(l);
    }
  }

  for (int i = 0; i < stack.size(); i++) {
    if (stack.pop() != queue.pop()) {
      palindrome = false;
      break;
    }
  }
  return palindrome;
}
\end{cpp}

\paragraph{Exercise~\ref{exs:palhask}} ~\\
