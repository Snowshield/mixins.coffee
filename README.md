# mixins.coffee 
Mixins support for coffeescript.
#####Example 1/4:
```coffeescript
class A
  constructor : ->
    @a_constructor = 0
  a_prototype : 1
class B extends Mixins
  constructor : ->
    @mixin A
console.log new B
```
######Result 1/4 (__proto__ is hided):
```javascript
B {
  a_constructor: 0,
  a_prototype: 1
}
```
Allow to copy both prototype and constructor variables to current class with **full inheritance support**.
#####Example 2/4:
```coffeescript
class A0
  constructor : ->
    @a0_constructor = 0
  a0_prototype : 1
class A1 extends A0
  constructor : ->
    super
    @a1_constructor = 0
  a1_prototype : 1
class B0
  constructor : ->
    @b0_constructor = 0
  b0_prototype : 1
class B1 extends B0
  constructor : ->
    super
    @b1_constructor = 0
  b1_prototype : 1
class B2 extends B1
  constructor : ->
    super
    @b2_constructor = 0
  b2_prototype : 1
#
class D extends Mixins
  constructor : ->
    @mixin A1, B2
console.log new D
```
######Result 2/4 (__proto__ is hided):
```javascript
D {
  a0_constructor: 0,
  a1_constructor: 0,
  b0_constructor: 0,
  b1_constructor: 0,
  b2_constructor: 0,
  a0_prototype: 1,
  a1_prototype: 1,
  b0_prototype: 1,
  b1_prototype: 1,
  b2_prototype: 1
}
```
Use `@mixinSafe` instead of `@mixin` to **see all conflicts** (variables with same names) in console.error. `@mixinSafe` is much slower so recomended to use **only in debug**.
#####Example 3/4:
```coffeescript
class A0
  constructor : ->
    @a0_constructor = 0
  a0_prototype : 0
class A1 extends A0
  constructor : ->
    super
    @a1_constructor = 1
  a1_prototype : 1
#
class B extends Mixins
  constructor : ->
    @mixinSafe A0, A1
console.log new B
```
######Result 3/4 (__proto__ is hided):
```javascript
Mix errors:
prototype(1): a0_prototype
constructor(1): a0_constructor
B {
  a0_constructor: 0,
  a1_constructor: 1,
  a0_prototype: 0,
  a1_prototype: 1
}
```
You also can **transfer arguments to parents' constructors**. Just add 'super' before `@mixin` or `@mixinSafe`.
#####Example 4/4:
```coffeescript
class A0
  constructor : (numbers...)->
    console.log numbers
class A1 extends A0
  constructor : (first, others...)->
    super
    console.log first
#
class D extends Mixins
  constructor : ->
    super
    @mixin A1
d = new D(1,2,3)
```
######Result 4/4:
```javascript
[1, 2, 3]
1
```