window.std ||= {}
window.std.Mixins = class Mixins
  constructor : -> @arguments = arguments
  mixinSafe : (parents...)->
    errProto = []
    errConstr = []
    # reg for 'this.<var> ='
    regThis = /this.[A-Za-z$_][A-Za-z$_0-9]*\s*=(?!=)/g
    # reg for '<var>'
    reg = /[A-Za-z$_][A-Za-z$_0-9]*/g
    parents.map (Parent)=>
      ctor = Parent::constructor
      # testing prototypes
      for key,val of Parent::
        unless ctor is val
          if @[key]? then errProto.push(key)
          @[key] = val
      # testing constructors (recursively)
      countErrConstr = (Par)=>
        testChild = {}
        # constructor function text
        text = Par.toString()
        # removing fat arrows
        text.match(regThis).map (str)->
          fatArrow = str+' bind('+str[...str.length-2]+', this);'
          text = text.replace(fatArrow, '')
        # results for 'this.<var> ='
        results = text.match(regThis)
        if results? # have results
        # 'this.'.length === 5
          vars = results.map (res) ->
            testChild[res[5..].match(reg)[0]] = null
        # counting repeats
        for key,val of testChild
          if @[key]? then errConstr.push(key)
        #recursion
        countErrConstr(Par.__super__.constructor) if Par.__super__?
      countErrConstr(Parent)
      # calling constructor Parent
      Parent.apply(@, @arguments)
    # sending error message
    if errProto.length+errConstr.length
      msg = [] ; msg.push('Mix errors:')
      if errProto.length
        msg.push "prototype(#{errProto.length}): #{errProto}"
      if errConstr.length
        msg.push "constructor(#{errConstr.length}): #{errConstr}"
      console.error msg.join('\n')
    delete @arguments; @
  mixin : (parents...)->
    parents.map (Parent)=>
      ctor = Parent::constructor
      for key,val of Parent::
        @[key] = val unless ctor is val
      Parent.apply(@, @arguments)
    delete @arguments; @