#Place all the behaviors and hooks related to the matching controller here.
#All this logic will automatically be available in application.js.
#You can use CoffeeScript in this file: http://coffeescript.org

show_data = (type_of_file) ->
  $('.upload_role').hide()
  $('.upload_track_category').hide()
  $('.upload_track').hide()
  if type_of_file == 'Track Categories' or type_of_file == 'Tracks' or type_of_file == 'Levels'
    $('.upload_role').show()
  if type_of_file == 'Tracks' or type_of_file == 'Levels'
    $('.upload_track_category').show()
  if type_of_file == 'Levels'
    $('.upload_track').show()
  return

load_data = (type_of_file) ->
  if type_of_file == 'Track Categories' or type_of_file == 'Tracks' or type_of_file == 'Levels'
    update_roles()
  if type_of_file == 'Tracks' or type_of_file == 'Levels'
    update_track_categories()
  if type_of_file == 'Levels'
    update_levels()
  return

update_roles = ->
  if $('#upload_role').text() == '\n'
    $.ajax
      url: 'uploads/get_roles'
      success: (data, textStatus, jqXHR) ->
        for i of data
          `i = i`
          $('#upload_role').append '<option value=' + data[i]._id.$oid + '>' + data[i].name + '</option>'
        return
  return

update_track_categories = ->
  $('#upload_role').change ->
    role_id = $('#upload_role').val()
    $.ajax
      url: 'uploads/get_track_categories'
      data: id: role_id
      success: (data, textStatus, jqXHR) ->
        $('#upload_track_category').empty()
        for i of data
          `i = i`
          $('#upload_track_category').append '<option value=' + data[i]._id.$oid + '>' + data[i].name + '</option>'
        return
    return
  return

update_levels = ->
  $('#upload_track_category').change ->
    track_category_id = $('#upload_track_category').val()
    $.ajax
      url: 'uploads/get_tracks'
      data: id: track_category_id
      success: (data, textStatus, jqXHR) ->
        $('#upload_track').empty()
        for i of data
          `i = i`
          $('#upload_track').append '<option value=' + data[i]._id.$oid + '>' + data[i].name + '</option>'
        return
    return
  return

$(document).on 'ready', ->
  load_data $('#upload_type_of_file').val()
  show_data $('#upload_type_of_file').val()
  $('#upload_type_of_file').change ->
    type_of_file = $('#upload_type_of_file').val()
    load_data type_of_file
    show_data type_of_file
    return
  return