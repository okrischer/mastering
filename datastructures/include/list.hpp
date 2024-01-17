#pragma once
#include <iostream>
#include <stdexcept>

// A generic container for storing one element of the given type
// and a pointer to the next element.
template<typename T>
class Node {
public:
  T data;
  Node* next;

  Node(int d, Node* n) : data{d}, next{n} {}
  ~Node() {}

  void print() {
    if (!next) std::cout << data << "\n";
    else {
      std::cout << data << " -> ";
      next->print();
    }
  }
};

// The puplic List interface, implemented by all lists.
template<typename T>
class List {
public:
  virtual ~List() {}
  virtual int size() const = 0;
  virtual void print() const = 0;
  virtual T peek() const = 0;
};

// A singly linked list with references to the head and the tail
// of the list.
template<typename T>
class LinkedList : public List<T> {
public:
  LinkedList() : head{nullptr}, tail{nullptr}, sz{0} {}
  ~LinkedList() {
    Node<T>* node = head;
    while(node) {
      Node<T>* curr = node;
      node = node->next;
      delete curr;
    }
  }

  // Returns the current size of the list.
  int size() const override {return sz;}

  // Prints the current list.
  void print() const override {
    if (!head) std::cout << "empty\n";
    else head->print();
  }

  // Returns the head of the list.
  // If the list is empty, an out_of_range exception is thrown.
  T peek() const override {
    if (head) return head->data;
    else throw std::out_of_range{"cannot peek from empty list"};
  }

  // Inserts a new element at the head of the list.
  void insertHead(T elem) {
    head = new Node<T>(elem, head);
    if (!tail) tail = head;
    sz++;
  }

  // Inserts a new element at the tail of the list.
  void insertTail(T elem) {
    if (!tail) insertHead(elem);
    else {
      tail->next = new Node<T>(elem, nullptr);
      tail = tail->next;
      sz++;
    }
  }

  // Removes and returns the head of the list.
  // If the list is empty, an out_of_range exception is thrown.
  T removeHead() {
    if (head) {
      Node<T>* first = head;
      T elem = head->data;
      head = head->next;
      delete first;
      sz--;
      return elem;
    } else throw std::out_of_range{"cannot remove from empty list"};
  }

private:
  Node<T>* head;
  Node<T>* tail;
  int sz;
};

// Stack implements a LIFO data structure based on linked lists.
// LIFO means `Last In - First Out`, i.e. the last added element
// is the first to be retrieved.
template<typename T>
class Stack : public List<T> {
public:
  Stack() {
    stack = new LinkedList<T>;
  }
  ~Stack() {
    delete stack;
  }

  // Returns the current size of the stack.
  int size() const override {
    return stack->size();
  }

  // Prints the current stack.
  void print() const override {
    stack->print();
  }

  // Returns the top element of the stack.
  // If the stack is empty, an out_of_range exception is thrown.
  T peek() const override {
    return stack->peek();
  }

  // Pushes a new element on top of the stack.
  void push(T elem) {
    stack->insertHead(elem);
  }

  // Removes and returns the top element of the stack.
  // If the stack is empty, an out_of_range exception is thrown.
  T pop() {
    return stack->removeHead();
  }

private:
  LinkedList<T>* stack;
};

// Queue implements a FIFO data structure based on linked lists.
// FIFO means `First In - First Out`, i.e. the first added element
// is the first to be retrieved.
template<typename T>
class Queue : public List<T> {
public:
  Queue() {
    queue = new LinkedList<T>;
  }
  ~Queue() {
    delete queue;
  }

  // Returns the current size of the queue.
  int size() const override {
    return queue->size();
  }

  // Prints the current queue.
  void print() const override {
    queue->print();
  }

  // Returns the head of the queue.
  // If the queue is empty, an out_of_range exception is thrown.
  T peek() const override {
    return queue->peek();
  }

  // Enqueues a new element at the tail of the queue.
  void enqueue(T elem) {
    queue->insertTail(elem);
  }

  // Removes and returns the head of the queue.
  // If the queue is empty, an out_of_range exception is thrown.
  T dequeue() {
    return queue->removeHead();
  }

private:
  LinkedList<T>* queue;
};

// Testing the interface

// Checks wether a given string is a palindrome.
bool is_palindrome(std::string s);
