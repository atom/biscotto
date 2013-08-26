Node      = require './node'

_         = require 'underscore'
_.str     = require 'underscore.string'

# A CoffeeScript method parameter
#
module.exports = class Parameter extends Node

  # Construct a parameter
  #
  # node - the node (a [Object])
  # options - the parser options (a [Object])
  #
  constructor: (@node, @options, @optionized) ->

  # Get the full parameter signature.
  #
  # Returns the signature (a [String])
  #
  getSignature: ->
    try
      unless @signature
        @signature = @getName()

        if @isSplat()
          @signature += '...'

        value = @getDefault()
        @signature += " = #{ value.replace(/\n\s*/g, ' ') }" if value

      @signature

    catch error
      console.warn('Get parameter signature error:', @node, error) if @options.verbose

  # Get the parameter name
  #
  # Returns the name (a [String])
  #
  getName: (i = -1) ->
    try
      # params like `method: ({option1, option2}) ->`
      if @optionized && i >= 0
        @name = @node.name.properties[i].base.value

      unless @name

        # Normal attribute `do: (it) ->`
        @name = @node.name.value

        unless @name
          if @node.name.properties
            # Assigned attributes `do: (@it) ->`
            @name = @node.name.properties[0]?.name?.value

      @name

    catch error
      console.warn('Get parameter name error:', @node, error) if @options.verbose

  # Get the parameter default value
  #
  # Returns the default (a [String])
  #
  getDefault: (i = -1) ->
    try
      # for optionized arguments
      if @optionized && i >= 0
        _.str.strip(@node.value?.compile({ indent: '' })[1..-2].split(",")[i]).split(": ")[1]
      else
        @node.value?.compile({ indent: '' })

    catch error
      if @node?.value?.base?.value is 'this'
        "@#{ @node.value.properties[0]?.name.compile({ indent: '' }) }"
      else
        console.warn('Get parameter default error:', @node, error) if @options.verbose

  getOptionizedDefaults: ->
    defaults = []
    for k in @node.value?.compile({ indent: '' }).split("\n")[1..-2]
      defaults.push _.str.strip(k.split(":")[0])

    return "{" + defaults.join(",") + "}"

  # Tests if the parameters is a splat
  #
  # Returns true if a splat (a [Boolean])
  #
  isSplat: ->
    try
      @node.splat is true

    catch error
      console.warn('Get parameter splat type error:', @node, error) if @options.verbose

  # Get a JSON representation of the object
  #
  # Returns the JSON object (a [Object])
  #
  toJSON: (i = -1) ->
    json =
      name: @getName(i)
      default: @getDefault(i)
      splat: @isSplat()
      optionized: @optionized

    json
