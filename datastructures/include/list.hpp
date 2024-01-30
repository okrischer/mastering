#pragma once
#include <stdexcept>

namespace list {

// Node is generic container for storing one element of the given type
// and a pointer to the next element.
template<typename T>
class Node {
public:
  T data;
  Node* next;

  Node(T d, Node* n) : data{d}, next{n} {}
  ~Node() {}
};

// Public interface for lists, implemented by Queue.
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

// Queue implements both FIFO and LIFO data structures based on List.
// For FIFO structures, elements are added to the tail, using push_back.
// For LIFO structures, elements are added to the head, using push_front.
// In both cases, the next element is taken from the head, using pop.
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
} // end of namespace list

// Testing the public interface

bool is_palindrome(std::string s);
bool is_balanced(std::string s);
