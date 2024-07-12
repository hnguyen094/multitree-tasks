based on [grit](https://github.com/climech/grit)

# TODO
- Resolve the complication of `TaskNode<ID>` (`Node<ID>` is an in-progress attempt.) Specifically, the Feature is managed but not used, so the new `Node<ID>` has specific Feature (Reducers) that ties in more closely with future Views (to create, edit, or link the node.)
  - In addition, it should allow for easy checking off of tasks (which doesn't work as the binding is not set up correctly.)
- Once `Node.Add` feature/reducer is completed, add a Date to tasks by default (that can be toggled Off, or cannot be changed if the multitree does not allow for it.) This would be added to Root (as Bag does not need to care about the differences between Dated nodes and UUID (user-generated) nodes.)
- Like grit, we should just manage Date nodes by default (including auto-create, auto-destroy.)
- 
- Test to see if a NavigationView is necessary when device is portrait (`compact` `horizontalClass`) (needs user testing)
- Create SwiftData equivalents to `Node`. `ancestorIDs` and `offspringIDs` can be regenerated.
