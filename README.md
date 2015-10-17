# mixins.coffee 
Mixins support for coffeescript.
Allow to copy both prototype and constructor variables to current class with **full inheritance support**.
Example:
```coffeescript
class A
  constructor : ->
    @a_constructor = 0
  a_prototype : 1
class B extends Mixins
  constructor : ->
    @mixin A
```
Use `<@mixinSafe>` instead of `<@mixin>` to **see all conflicts** (variables with same names) in console.error.
Example:
```coffeescript
class A0
  constructor : ->
    @a00_constructor = 0
  a01_prototype : 1
class A1 extends A0
  constructor : ->
    super
    @a10_constructor = 0
  a11_prototype : 1
class B0
  constructor : ->
    @b00_constructor = 0
  b01_prototype : 1
class B1 extends B0
  constructor : ->
    super
    @b10_constructor = 0
  b11_prototype : 1
class C0
  constructor : ->
    @c00_constructor = 0
  c01_prototype : 1
class C1 extends C0
  constructor : ->
    super
    @c10_constructor = 0
  c11_prototype : 1
#
class D extends Mixins
  constructor : ->
    @mixinSafe A1, B1, C1
d = new D
```

You also can **transfer arguments to parents' constructors**. Just add 'super' before `<@mixin>` or `<@mixinSafe>`.
Example:
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