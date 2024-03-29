# 7GUIs Challenge done in IUPforZig

The 7GUIs is a set of 7 tasks to be implemented using a GUI proposed by Eugen Kiss in his master's thesis as a way to evaluate GUI toolkits. By implementing those 7 task one should be able to compare different GUIs in any language with a similar comparison base. See his web site for more details on the task and on the proposed evaluation: https://eugenkiss.github.io/7guis/.

The tasks will also help beginners to understand simple and complex tasks in GUI programming serving as a common tutorial.

## 1. Counter

*Challenge*: Understanding the basic ideas of a language/toolkit.

![counter](assets/counter.png)

[counter.zig](counter.zig)

## 2. Temperature Converter

*Challenges*: bidirectional data flow, user-provided text input.

![tempConv](assets/temp_conv.png)

[temp_conv.zig](temp_conv.zig)

## 3. Flight Booker

*Challenge*: Constraints.

![FlightBooker](assets/flightBooker.png)
![FlightBooker](assets/flightBooker_dialog.png)

[book_flight.zig](book_flight.zig)

## 4. Timer

*Challenges*: concurrency, competing user/signal interactions, responsiveness.

![Timer](assets/timer.png)

[timer.zig](timer.zig)

## 5. CRUD

*Challenges*: separating the domain and presentation logic, managing mutation, building a non-trivial layout.

![CRUD](assets/crud.png)

[crud.zig](crud.zig)

## 6. Circle Drawer

*Challenges*: undo/redo, custom drawing, dialog control.

![Circle](assets/circle.png)
![Circle Radius](assets/circle_radius.png)

[circle.zig](circle.zig)

## 7. Cells

*Challenges*: change propagation, widget customization, implementing a more authentic/involved GUI application.

![Cells](assets/cells.png)

[cells.zig](cells.zig)

# How to run

1. Please refer to [how to build](../ReadMe.md#how-to-build).

2. Each task can be launched by `zig build` using the corresponding task name.

Run `zig build --help` for more details:

```
Steps:
  counter                      7GUI Counter
  tempConv                     7GUI Temperature Converter
  bookFlight                   7GUI Flight Booker
  timer                        7GUI Timer
  crud                         7GUI Crud
  circle                       7GUI Circle Drawer
  cells                        7GUI Cells
```

Example:

```sh
zig build cells
```

# Acknowledgements

### 7GUIs reference implementation
https://eugenkiss.github.io/7guis-React-TypeScript-MobX/

### 7GUIs implementation in IUP
https://www.tecgraf.puc-rio.br/iup/en/7gui/7gui.html
