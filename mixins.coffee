class Mixins
  constructor : -> @arguments = arguments
  mixinSafe : (parents...)->
    errProto = 0
    errConstr = 0
    @:: ?= {} # init prototype
    parents.map (Parent)->
      ctor = Parent::constructor
      # testing prototypes
      for key,val of Parent::
        unless ctor is val
          if @::[key]? then errProto++
          @::[key] = val
      # testing constructors
      testChild = {}
      Parent.apply(testChild, @arguments)
      for key,val of testChild
        if @[key]? then errConstr++
      Parent.apply(@, @arguments)
      # sending error message
      if errProto+errConstr
        msgTitle = 'Mix errors: '
        msg = []
        msg.push "#{errProto}(prototype)" if errProto
        msg.push "#{errConstr}(constructor)" if errConstr
        console.error msgTitle+msg.join(', ')
    ,@
    delete @arguments; @
  mixin : (parents...)->
    parents.map (Parent)->
      ctor = Parent::constructor
      @:: ?= {} # init prototype
      for key,val of Parent::
        @::[key] = val unless ctor is val
      Parent.apply(@, @arguments)
    ,@
    delete @arguments; @