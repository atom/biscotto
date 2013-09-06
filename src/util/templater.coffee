fs      = require 'fs'
path    = require 'path'
mkdirp  = require 'mkdirp'
_       = require 'underscore'
_.str   = require 'underscore.string'
walkdir = require 'walkdir'
hamlc   = require 'haml-coffee'
GitUtils = require 'git-utils'

# Haml Coffee template compiler.
#
module.exports = class Templater

  # Construct the templater. Reads all templates and constructs
  # the global template context.
  #
  # options - the options (a [Object])
  # referencer - the link type referencer (a [Referencer])
  # parser - the biscotto parser (a [Parser])
  #
  constructor: (@options, @referencer, @parser) ->
    @JST = []

    @globalContext =
      biscottoVersion: 'v' + JSON.parse(fs.readFileSync(path.join(__dirname, '..', '..', 'package.json'), 'utf-8'))['version']
      generationDate: new Date().toString()
      JST: @JST
      underscore: _
      str: _.str
      title: @options.title
      referencer: @referencer
      analytics: @options.analytics
      fileCount: @parser.files.length
      classCount: @parser.classes.length
      mixinCount: @parser.mixins.length
      methodCount: @parser.getAllMethods().length
      extraCount: _.union([@options.readme], @options.extras).length
      repo: @gitHubUrl(_.str.strip(@options.tag))

    for filename in walkdir.sync path.join(__dirname, '..', '..', 'theme', 'default', 'templates')
      if match = /theme[/\\]default[/\\]templates[/\\](.+).hamlc$/.exec filename
        @JST[match[1]] = hamlc.compile(fs.readFileSync(filename, 'utf-8'))

  # Redirect template generation to a callback.
  #
  # file - the file callback function (a [Function])
  #
  redirect: (file) -> @file = file

  # Render the given template with the context and the
  # global context object merged as template data. Writes
  # the file as the output filename.
  #
  # template - the template name (a [String])
  # context - the context object (a [Object])
  # filename - the output file name (a [String])
  #
  render: (template, context = {}, filename = '') ->
    html = @JST[template](_.extend(@globalContext, context))

    unless _.isEmpty filename

      # Callback generated content
      if @file
        @file(filename, html)

      # Write to file system
      else
        unless @options.noOutput
          file = path.join @options.output, filename
          dir  = path.dirname(file)
          mkdirp dir, (err) =>
            if err
              console.error "[ERROR] Cannot create directory #{ dir }: #{ err }"
            else
              fs.writeFile file, html

    html

  gitHubUrl: (tag) ->
    repo = GitUtils.open('/Users/garentorikian/Development/biscotto/.git')

    return null unless repo?

    url = repo.getConfigValue("remote.origin.url")

    if url.match /https:\/\/github.com\// # e.g., https://github.com/foo/bar.git
      githubRepoUrl = url.replace(/\.git$/, '')
    else if url.match /git@github.com/    # e.g., git@github.com:foo/bar.git
      githubRepoUrl = url.
        replace(/^git@github.com:/, 'https://github.com/').
        replace(/\.git$/, '')

    "#{githubRepoUrl}/blob/#{tag}"
