// Node modules
var gulp = require('gulp')
var watch = require('gulp-watch')
var plumber = require('gulp-plumber')
var preservetime = require('gulp-preservetime')
var replaceExt = require('replace-ext')
var log = require('fancy-log')
var tap = require('gulp-tap')
var sass = require('gulp-sass')
var minify = require('gulp-cssnano')
var print = require('gulp-print')

var File = require('vinyl')
var fs = require('fs')

var hljs = require('highlight.js')
var server = require('gulp-server-livereload')
var del = require('del')
var path = require('path')
var mkdirp = require('mkdirp')
var slugify = require('slugify')
var through = require('through2')
var frontmatter = require('front-matter')
var markdown = require('markdown-it')
var md_attrs = require('markdown-it-attrs')
var md_deflist = require('markdown-it-deflist')
var md_sub = require('markdown-it-sub')
var md_sup = require('markdown-it-sup')
var md_katex = require('markdown-it-katex')
var remotesrc = require('gulp-remote-src')
var merge = require('merge-stream');

var depsdir = './.deps/'

// hljs lua highlight patched
try {
  var lua = require(depsdir + 'lua')
  hljs.registerLanguage('lua', lua.lua)
} catch (e) {
  log('Missing dependency. Run \'gulp dependencies\'.')
}

md = new markdown({
  html: true,
  xhtmlOut: true,
  breaks: false,
  langPrefix: 'language-',
  linkify: true,
  typographer: true,
  highlight: function (str, lang) {
    if (lang && hljs.getLanguage(lang)) {
      try {
        var hl = hljs.highlight(lang, str).value
        // Callouts hack!
        return hl.replace(/(?:--|\/\/|#) &lt;([0-9]+)&gt;/g, '<span class="callout" data-pseudo-content="$1"></span>')
      } catch (__) {}
    }
    return '' // use external default escaping
  }
})

md.use(md_deflist)
md.use(md_attrs)
md.use(md_sub)
md.use(md_sup)
md.use(md_katex)

function slugname(str) {
  return '_' + slugify(str, '_').toLowerCase()
}

// Images.
md.renderer.rules.image = function (tokens, idx, options, env, self) {
  var token = tokens[idx]

  if ('imgurl' in env) {
    // Rewrite src
    var src = token.attrs[token.attrIndex('src')][1]
    token.attrs[token.attrIndex('src')][1] = env.imgurl + '/' + src
  }
  // Set alt attribute
  token.attrs[token.attrIndex('alt')][1] = self.renderInlineAsText(token.children, options, env)

  return self.renderToken(tokens, idx, options)
}

function injectScript(filename) {
  var content = fs.readFileSync(filename).toString()
  var code = ''
  var annotation = ''
  var start = content.search(/^--\[\[/m)
  var end = content.search(/^--\]\]/m)
  if (start >= 0 && end >= 0) {
    code = content.substring(0, start)
    annotation = content.substring(start + 5, end)
  } else {
    code = content
  }
  // Tabs to spaces.
  code = code.replace(/[\t]/g, '    ')

  // Remove trailing empty lines.
  code = code.replace(/[\s\n]+$/, '')

  var s = '\n`' + path.basename(filename) + '`{.scriptfilelabel}\n'
  s += '```lua\n'
  s += code
  s += '\n```\n'
  s += annotation + '\n'
  return s
}

// Output preview html documents
function markdownToPreviewHtml(file) {
  var data = frontmatter(file.contents.toString())
  var absdir = path.dirname(file.path)

  // Inject some styling html for the preview. The built htmls are clean.
  var head = '<!DOCTYPE html><html><head><link type="text/css" rel="stylesheet" href="/preview-md.css">' +
    '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.7.1/katex.min.css" integrity="sha384-wITovz90syo1dJWVh32uuETPVEtGigN07tkttEqPv+uR2SE/mbQcG7ATL28aI9H0" crossorigin="anonymous">' +
    '</head><body>\n'
  head += '<div class="documentation">\n'
  head += '<h1>' + data.attributes.title + '</h1>\n'
  head += '<p>' + data.attributes.brief + '</p>\n'

  var scriptmd = ''
  if (data.attributes.scripts) {
    var scriptfiles = data.attributes.scripts.split(/[,]\s*/)
    var scriptpaths = scriptfiles.map(function (e) { return absdir + '/' + e })
    scriptmd = scriptpaths.map(injectScript).join('')
  }

  var foot = '</div></body></html>\n'
  var html = head + md.render(data.body + scriptmd) + foot
  file.contents = new Buffer(html)
  file.path = replaceExt(file.path, '.html')
  return
}

var img_url = 'https://storage.googleapis.com/defold-examples'
//var img_url = '/_ah/gcs/defold-doc'; // local dev-server

// Build document json for storage
function markdownToJson(file) {
  var name = path.relative(file.base, file.path)
  var dir = path.dirname(name)
  var absdir = path.dirname(file.path)

  // Needs language for static image url:s
  var data = frontmatter(file.contents.toString())

  var scriptmd = ''
  if (data.attributes.scripts) {
    var scriptfiles = data.attributes.scripts.split(/[,]\s*/)
    var scriptpaths = scriptfiles.map(function (e) { return absdir + '/' + e })
    scriptmd = scriptpaths.map(injectScript).join('')
  }

  var env = {imgurl: img_url + '/' + dir}
  data.html = md.render(data.body + scriptmd, env)
  data.toc = env.toc
  file.contents = new Buffer(JSON.stringify(data))
  file.path = replaceExt(file.path, '.json')
  return
}

function index(jsonfile) {
  var index_map = {}
  var categories = {}
  return through.obj(function (file, enc, cb) {
    var fullpath = path.relative(file.base, file.path)
    var dir = path.dirname(fullpath)

    var m = dir.match(/^([^/]+)[/]([^/]+)$/)
    var category = m[1]
    var example = m[2]
    var data = JSON.parse(file.contents)

    if (!categories[category]) {
      categories[category] = {name: category, items: []}
    }
    var expath = '/examples/' + category + '/' + example
    var ex = {path: expath, name: data.attributes.title}
    categories[category]['items'].push(ex)
    cb(null, file)
  }, function (cb) {
    var cat_array = []
    for (var cat in categories) {
      cat_array.push(categories[cat])
    }

    index_map['categories'] = cat_array
    f = new File({
      path: jsonfile,
      contents: new Buffer(JSON.stringify(index_map))
    })
    this.push(f)
    cb()
  })
}

function fetchLua () {
  return remotesrc(['lua.js'], {
    base: 'https://raw.githubusercontent.com/defold/doc/master/lib/'
  })
    .pipe(gulp.dest(depsdir))
}

function fetchPreview () {
  return remotesrc(['preview-md.sass'], {
    base: 'https://raw.githubusercontent.com/defold/doc/master/docs/sass/'
  })
    .pipe(gulp.dest(depsdir))
}

function dependencies () {
  return merge(fetchLua(), fetchPreview())
}

function clean () {
  return del(['build'])
}

function copyAssets () {
  return gulp.src(['examples/**/*.{png,jpg,svg,gif,js,zip,js}'])
    .pipe(gulp.dest('build/web'))
    .pipe(preservetime())
}

function build () {
  return gulp.src('examples/**/*.md')
    .pipe(tap(markdownToJson))
    .pipe(index('index.json'))
    .pipe(gulp.dest('build/web/'))
    .pipe(preservetime())
}

function compilePreviewAssets () {
  return gulp.src('examples/**/*.{png,jpg,svg,gif}')
    .pipe(gulp.dest('build/web/preview'))
}

function watchAssets () {
  return watch('examples/**/*.{png,jpg,svg,gif}', compilePreviewAssets)
}

function compilePreviewMarkdown () {
  return gulp.src('examples/**/*.md')
    .pipe(tap(markdownToPreviewHtml))
    .pipe(print())
    .pipe(gulp.dest('build/web/preview'))
}

function watchMarkdown () {
  return watch('examples/**/*.md', compilePreviewMarkdown)
}

function compilePreviewSass () {
  return gulp.src('.deps/preview-md.sass')
    .pipe(plumber())
    .pipe(sass())
    .pipe(minify())
    .pipe(gulp.dest('build/web/preview'))
}

function watchSass () {
  return watch(['.deps/**/*.sass'], compilePreviewSass)
}

function createPreviewDir (done) {
  mkdirp('build/web/preview', done)
}

function serve () {
  return gulp.src('build/web/preview')
    .pipe(server({
      livereload: true,
      open: true,

      directoryListing: {
        enable: true,
        path: './build/web/preview'
      }
    }))
}

gulp.task('dependencies', dependencies)
gulp.task('clean', clean)

// Build docs
gulp.task('build', gulp.series(dependencies, clean, copyAssets, build))

gulp.task('preview-assets', compilePreviewAssets)
gulp.task('preview-md', compilePreviewMarkdown)
gulp.task('sass', compilePreviewSass)

// Watch for changes in md files and compile new HTML
gulp.task('watch',
  gulp.series(
    createPreviewDir,
    compilePreviewAssets,
    compilePreviewMarkdown,
    compilePreviewSass,
    gulp.parallel(
      serve,
      watchSass,
      watchAssets,
      watchMarkdown
    )
  )
)
