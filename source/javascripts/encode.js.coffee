(($) ->

  $(->
    if typeof FileReader == 'function' && 'draggable' of document.createElement 'span'
      $('.drop-area').omni2data()
    else
      $('body').addClass('caution').find('h1').after '<p class="caution">Oops, your browser doesn\'t support the features this app requires.</p>'
  )

  $.fn.omni2data = ->
    @each ->
      new Omni2data $(@)

  class Omni2data
    constructor: ($el) ->
      @$el = $el
      @$body = $('body')
      @$info = @$body.find '.info'
      @file
      @_eventify()

    _eventify: ->
      $.each ['dragenter', 'dragover', 'dragleave', 'drop'], (id, val) =>
        @$el.get(0).addEventListener val, @[val], true

    _init: (event) ->
      event.stopPropagation()
      event.preventDefault()

    dragenter: (e) =>
      @_init e
      @$el.addClass 'active'

    dragover: (e) =>
      @_init e

    dragleave: (e) =>
      @_init e
      @$el.removeClass 'active'

    drop: (e) =>
      @_init e
      @$body.toggleClass 'complete'
      @$el.removeClass 'active'

      files = e.dataTransfer.files

      $.each files, (id, file) =>
        reader = new FileReader()
        reader.onload = =>
          dataURI = reader.result

          @_setFileInfo file, dataURI
          @_generateImage file, dataURI

        reader.readAsDataURL file

    _setFileInfo: (file, dataURI) =>
      filesize = file.size
      datasize = dataURI.length
      fat = (datasize - filesize)

      @$info
        .find('.filename').text(file.name).end()
        .find('.filetype').text(file.type).end()
        .find('.filesize').text(filesize + 'bytes').end()
        .find('.datasize').text(datasize + 'bytes(' + ((fat / filesize).toFixed(1) * 100) + '%)').end()
        .find('.datauri').text(dataURI)

    _generateImage: (file, dataURI) =>
      if /^image/.test file.type
        img = $('<img>')
        img.attr 'src', dataURI

        @$el.html img

      else
        @$el.text file.name

) jQuery
