#pragma once
#include <iostream>
#include <stdexcept>

namespace list {

// A generic container for storing one element of the given type
// and a pointer to the next element.
template<typename T>
class Node {
public:
  T data;
  Node* next;

  Node(T d, Node* n) : data{d}, next{n} {}
  ~Node() {}
};

// The puplic List interface, implemented by all lists.
template<typename T>
class List {
public:
  virtual ~List() {}
  virtual int size() const = 0;
  virtual T peek(int n) = 0;
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

  // Returns the element with the given index (starting with 1).
  // If there is no element at the given index, an exception is thrown.
  T peek(int n) override {
    Node<T>* node = head;
    for (int i = 1; i < n && i < sz; i++) {
      node = node->next;
    }
    if (node) return node->data;
    else throw std::out_of_range{"List::peek()"};
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
  // If the list is empty, an exception is thrown.
  T removeHead() {
    if (head) {
      Node<T>* first = head;
      T elem = head->data;
      head = head->next;
      delete first;
      sz--;
      return elem;
    } else throw std::out_of_range{"List::removeHead()"};
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

  // Returns the top element of the stack.
  // If the stack is empty, an out_of_range exception is thrown.
  T peek(int n) override {
    return stack->peek(n);
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

  // Returns the head of the queue.
  // If the queue is empty, an out_of_range exception is thrown.
  T peek(int n) override {
    return queue->peek(n);
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
} // end of list

// Testing the interface

bool is_palindrome(std::string s);
bool is_balanced(std::string s);
