# MaterialSwitcher

Animates child widgets with a material transitions. Similar to Flutter's own `AnimatedSwitcher`.

###### Switcher being used on a list view as it loads in.

```dart
Widget list;
switch (listStatus) {
  case ListStatus.loading:
    list = CircularProgressIndicator();
    break;
  case ListStatus.empty:
    list = Text('Nothing here');
    break;
  case ListStatus.paginated:
    list = ListView(...);
    break;
}

return MaterialSwitcher.vertical(child: list);
```

## MaterialImage

Allows loading image providers widget with material transitions. Similar to Flutter's `Image` widget.

###### Image provider being passed to the `MaterialImage`.

```dart
return MaterialImage(
  imageProvider: NetworkImage(...),
  idleChild: CircularProgressIndicator(),
);
```

## MaterialView

Allows swiping through widgets the same way Flutter's `PageView` does, except the children are animated with material shared axis transitions, instead of linear drag.
