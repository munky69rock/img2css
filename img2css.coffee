if not window.FileReader
  alert "sorry, your browser doesn't support file api."


readImage = (file) ->
  reader = new FileReader()
  $(reader).bind('load', (evt) ->
    image = new Image()
    image.src = evt.target.result
    img2css(image)
    return
  )
  reader.readAsDataURL(file)
  return

convert = ->
  $file = $('#file')
  filelist = $file.prop('files')

  if filelist.length is 0
    alert 'please select image file.'
    return

  file = filelist[0]
  if file.type.indexOf('image') isnt -1
    readImage(file)
  else
    alert "not image file: #{file.name}"
  return

img2css = (img) ->
  #canvas = document.createElement 'canvas'
  canvas = $('#canvas').get(0)

  for key in ['width', 'height']
    canvas[key] = img[key]

  ctx = canvas.getContext '2d'
  ctx.drawImage(img, 1, 1)

  unit = 5
  x = 0
  y = 0
  box_shadow = []
  console.log 'start'
  while x < canvas.width
    while y < canvas.height
      box_shadow.push "#{x}px #{y}px 4px 5px rgba(#{getRGBAAvg(ctx.getImageData(x, y, 5, 5).data).join(',')})"
      y += unit
    y = 0
    x += unit
  console.log 'complete'

  $('#view').css(
    boxShadow: box_shadow.join(',')
  )
  $('body').css(
    height: $('body').height() + img.height + 100
  )
  return

getRGBAList = (data) ->
  rgbaList = []
  for n, i in data
    j = Math.floor(i/4)

    if not rgbaList[j]
      rgbaList[j] = [] # [r, g, b, a] 

    rgbaList[j][i % 4] = n
  return rgbaList

getRGBAAvg = (data) ->
  list = getRGBAList(data)
  rgba = [0, 0, 0, 0]

  for _rgba in list
    for i in [0 .. 3]
      rgba[i] += _rgba[i]

  for i in [ 0 .. 3 ]
    rgba[i] = Math.floor(rgba[i]/list.length)

  return rgba

$(->
  $('#convert').bind('click', convert)
)
