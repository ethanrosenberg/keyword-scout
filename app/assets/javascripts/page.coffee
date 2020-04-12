App.room = App.cable.subscriptions.create "WebNotificationsChannel",
  received: (data) ->
    $('#search_' + data['id'] +  '> td.col.col-results').text data['results']
