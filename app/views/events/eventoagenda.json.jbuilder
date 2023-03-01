json.array!(@events) do |event|
  json.extract! event, :id, :title 
  json.start event.data_inicio  
  json.end event.data_fim 
  json.backgroundColor '#9297dd'
  json.borderColor '#9297dd'
end