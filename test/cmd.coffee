
after = require 'after'
assert = require 'assert'
child_process = require 'child_process'
fs = require 'fs'
mkdirp = require 'mkdirp'
mocha = require 'mocha'
path = require 'path'
request = require 'supertest'
rimraf = require 'rimraf'

binPath = path.resolve __dirname, '../bin/express-cs'
tempDir = path.resolve __dirname, '../temp'

describe 'express(1)', ->
  before (done) ->
    @timeout 30000
    cleanup done

  after (done) ->
    @timeout 30000
    cleanup done


  describe '(no args)', ->
    dir = files = null

    before (done) ->
      createEnvironment (err, newDir) ->
        return done err if err?
        dir = newDir
        done()

    after (done) ->
      @timeout 30000
      cleanup dir, done

    it 'should create basic app', (done) ->
      run dir, [], (err, stdout) ->
        return done err if err?
        files = parseCreatedFiles stdout, dir
        assert.equal files.length, 17
        done()

    it 'should have basic files', ->
      assert.notEqual files.indexOf('bin/www'), -1
      assert.notEqual files.indexOf('app.coffee'), -1
      assert.notEqual files.indexOf('package.json'), -1

    it 'should have jade templates', ->
      assert.notEqual files.indexOf('views/error.jade'), -1
      assert.notEqual files.indexOf('views/index.jade'), -1
      assert.notEqual files.indexOf('views/layout.jade'), -1

    it 'should have a package.json file', ->
      file = path.resolve dir, 'package.json'
      contents = fs.readFileSync file, 'utf8'
      assert.equal contents, 
        """
        {
          "name": #{JSON.stringify path.basename dir},
          "version": "0.0.0",
          "private": true,
          "scripts": {
            "start": "coffee ./bin/www"
          },
          "dependencies": {
            "body-parser": "~1.10.1",
            "coffee-script": "^1.8.0",
            "cookie-parser": "~1.3.3",
            "debug": "~2.1.1",
            "express": "~4.11.0",
            "jade": "~1.9.0",
            "morgan": "~1.5.1",
            "serve-favicon": "~2.2.0"
          }
        }
        """

    it 'should have installable dependencies', (done) ->
      @timeout 30000
      npmInstall dir, done
      null

    it 'should export an express app from app.coffee', ->
      file = path.resolve dir, 'app.coffee'
      app = require file
      assert.equal (typeof app), 'function'
      assert.equal (typeof app.handle), 'function'

    it 'should respond to HTTP request', (done) ->
      file = path.resolve dir, 'app.coffee'
      app = require file

      request(app)
      .get '/'
      .expect 200, /<title>Express<\/title>/, done

  describe '--ejs', ->
    dir = files = null

    before (done) ->
      createEnvironment (err, newDir) ->
        return done err if err?
        dir = newDir
        done()

    after (done) ->
      @timeout 30000
      cleanup dir, done


    it 'should create basic app with ejs templates', (done) ->
      run dir, ['--ejs'], (err, stdout) ->
        return done err if err?
        files = parseCreatedFiles stdout, dir
        assert.equal files.length, 16, 'should have 16 files'
        done()

    it 'should have basic files', ->
      assert.notEqual files.indexOf('bin/www'), -1, 'should have bin/www file'
      assert.notEqual files.indexOf('app.coffee'), -1, 'should have app.coffee file'
      assert.notEqual files.indexOf('package.json'), -1, 'should have package.json file'


    it 'should have ejs templates', ->
      assert.notEqual files.indexOf('views/error.ejs'), -1, 'should have views/error.ejs file'
      assert.notEqual files.indexOf('views/index.ejs'), -1, 'should have views/index.ejs file'


    it 'should have installable dependencies', (done) ->
      @timeout 30000
      npmInstall dir, done


    it 'should export an express app from app.coffee', ->
      file = path.resolve dir, 'app.coffee'
      app = require file
      assert.equal (typeof app), 'function'
      assert.equal (typeof app.handle), 'function'

    it 'should respond to HTTP request', (done) ->
      file = path.resolve dir, 'app.coffee'
      app = require file

      request(app)
      .get '/'
      .expect 200, /<title>Express<\/title>/, done

  describe '--git', ->
    dir = files = null

    before (done) ->
      createEnvironment (err, newDir) ->
        return done err if err?
        dir = newDir
        done()

    after (done) ->
      @timeout 30000
      cleanup dir, done

    it 'should create basic app with git files', (done) ->
      run dir, ['--git'], (err, stdout) ->
        return done err if err?
        files = parseCreatedFiles stdout, dir
        assert.equal files.length, 18, 'should have 18 files'
        done()

    it 'should have basic files', ->
      assert.notEqual files.indexOf('bin/www'), -1, 'should have bin/www file'
      assert.notEqual files.indexOf('app.coffee'), -1, 'should have app.coffee file'
      assert.notEqual files.indexOf('package.json'), -1, 'should have package.json file'

    it 'should have .gitignore', ->
      assert.notEqual files.indexOf('.gitignore'), -1, 'should have .gitignore file'

    it 'should have jade templates', ->
      assert.notEqual files.indexOf('views/error.jade'), -1
      assert.notEqual files.indexOf('views/index.jade'), -1
      assert.notEqual files.indexOf('views/layout.jade'), -1

  describe '-h', ->
    dir = null

    before (done) ->
      createEnvironment (err, newDir) ->
        return done err if err?
        dir = newDir
        done()

    after (done) ->
      @timeout 30000
      cleanup dir, done

    it 'should print usage', (done) ->
      run dir, ['-h'], (err, stdout) ->
        return done err if err?
        files = parseCreatedFiles stdout, dir
        assert.equal files.length, 0
        assert.ok /Usage: express/.test stdout
        assert.ok /--help/.test stdout
        assert.ok /--version/.test stdout
        done()

  describe '--hbs', ->
    dir = files = null

    before (done) ->
      createEnvironment (err, newDir) ->
        return done err if err?
        dir = newDir
        done()

    after (done) ->
      @timeout 30000
      cleanup dir, done

    it 'should create basic app with hbs templates', (done) ->
      run dir, ['--hbs'], (err, stdout) ->
        return done err if err?
        files = parseCreatedFiles(stdout, dir);
        assert.equal(files.length, 17);
        done()

    it 'should have basic files', ->
      assert.notEqual files.indexOf('bin/www'), -1
      assert.notEqual files.indexOf('app.coffee'), -1
      assert.notEqual files.indexOf('package.json'), -1

    it 'should have hbs templates', ->
      assert.notEqual files.indexOf('views/error.hbs'), -1
      assert.notEqual files.indexOf('views/index.hbs'), -1
      assert.notEqual files.indexOf('views/layout.hbs'), -1

    it 'should have installable dependencies', (done) ->
      @timeout 30000
      npmInstall dir, done

    it 'should export an express app from app.coffee', ->
      file = path.resolve dir, 'app.coffee'
      app = require file
      assert.equal (typeof app), 'function'
      assert.equal (typeof app.handle), 'function'

    it 'should respond to HTTP request', (done) ->
      file = path.resolve dir, 'app.coffee'
      app = require file

      request(app)
      .get '/'
      .expect 200, /<title>Express<\/title>/, done


  describe '--help', ->
    dir = null

    before (done) ->
      createEnvironment (err, newDir) ->
        return done err if err?
        dir = newDir
        done()

    after (done) ->
      @timeout 30000
      cleanup dir, done

    it 'should print usage', (done) ->
      run dir, ['--help'], (err, stdout) ->
        return done err if err?
        files = parseCreatedFiles stdout, dir
        assert.equal files.length, 0
        assert.ok /Usage: express/.test stdout
        assert.ok /--help/.test stdout
        assert.ok /--version/.test stdout
        done()


cleanup = (dir, callback) ->
  if typeof dir is 'function'
    callback = dir
    dir = tempDir

  rimraf tempDir, (err) ->
    callback err

createEnvironment = (callback) ->
  num = process.pid + Math.random()
  dir = path.join tempDir, "app-#{num}"
  ondir = (err) ->
    return callback err if err?
    callback null, dir
  mkdirp dir, ondir

npmInstall = (dir, callback) ->
  child_process.exec 'npm install', {cwd: dir}, (err, stderr) ->
    if err?
      err.message += stderr
      callback err

    callback()



parseCreatedFiles = (output, dir) ->
  files = []
  lines = output.split /[\r\n]+/
  match = null

  for line in lines
    if match = /create.*?: (.*)$/.exec line
      file = match[1]

      if dir
        file = path.resolve dir, file
        file = path.relative dir, file

      file = file.replace /\\/g, '/'
      files.push file
  files

run = (dir, args, callback) ->

  ondone = (err) ->
    err = null
    stdout = Buffer.concat(chunks)
      .toString('utf8')
      .replace /\x1b\[(\d+)m/g, '_color_$1_'

    try
      assert.equal Buffer.concat(stderr).toString('utf8'), ''
    catch error
      err = error

    callback err, stdout

  argv = [binPath].concat args
  chunks = []
  done = after 2, ondone
  exec = process.argv[0]
  stderr = []

  child = child_process.spawn exec, argv,
    cwd: dir

  ondata = (chunk) -> chunks.push chunk
  child.stdout.on 'data', ondata

  ondata = (chunk) -> stderr.push chunk
  child.stderr.on 'data', ondata

  onclose = () ->
    done()
  child.on 'close', onclose
  child.on 'error', callback
  child.on 'exit', done
