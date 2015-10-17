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
      testChild = {}; text = Parent.toString()
      # reg for 'this.<var> ='
      this_reg_equal = /this.[A-Za-z$_][A-Za-z$_0-9]*\s*=/g
      # reg for '<var>'
      reg = /[A-Za-z$_][A-Za-z$_0-9]*/g
      # results for 'this.<var> ='
      results = text.match(this_reg_equal)
      if results? # have results
        vars = results.map (res) -> # 5 is 'this.'.length
          testChild[res[5..].match(reg)[0]] = null
      # counting repeats
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